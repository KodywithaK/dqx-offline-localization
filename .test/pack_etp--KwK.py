import argparse
import glob
import json
import os
from struct import unpack, iter_unpack
from subprocess import run
import sqlite3
import sys
sys.path.append("../../")  # hack to use tools
from tools.lib.fileops import (
    pack_uint,
    pack_ushort,
    unpack_uint,
    unpack_ushort,
    write_foot,
    write_text
)
from tools.dump_etps.dqxcrypt.dqxcrypt import (
    attach_client,
    encrypt
)


def read_json_file(file: str):
    with open(file, "r", encoding="utf-8") as f:
        contents = f.read()
        return json.loads(contents)


def align_file(file_obj: object, alignment: int):
    """
    Add padding to end of file
    until the number is divisible by alignment.
    """
    # add 00 padding to file to meet alignment needs.
    while True:
        eof = file_obj.seek(0, 2) / alignment
        check_int = float(eof).is_integer()
        if check_int:
            return True
        file_obj.write(b"\x00")


def determine_etp_version(file: str) -> int:
    with open(file, "rb") as f:
        evtx_header = unpack("4s", f.read(4))[0]
        if evtx_header != b"EVTX":
            return None
        f.read(11)
        version = f.read(1)
    return int(version.hex())


def find_versioned_files(version: int):
    # etps = glob.glob("../dump_etps/etps/*.etp")
    etps = glob.glob("../dump_etps/AppID_1358750/BuildID_14529657/REFERENCES/pakchunk0-{PLATFORM}.pak/Game/Content/NonAssets/ETP/*.etp") #KwK
    files = []
    for etp in etps:
        with open(etp, "rb") as f:
            junk = f.read(15)
            file_ver = unpack("b", f.read(1))[0]
            if version == file_ver:
                files.append(etp)
    return files


def get_string_bytes(json_list: list, search_key: str, ensure_even_bytes=False):
    str_bytes = b""
    # en = json_list[search_key]['en'] #KwK
    language = json_list[search_key][args.pack_all_language] #KwK
    # print(f"language = {language}") #KwK
    ja = json_list[search_key]['ja'] #KwK
    # ja, en = next(iter(json_list[search_key].items()))
    # print(f"\n{ja}\n{en}\n") #KwK
    # os.system("PAUSE") #KwK
    if language == "":
        str_bytes = bytes(ja, encoding="utf-8") + b"\x00"
    else:
        str_bytes = bytes(language, encoding="utf-8") + b"\x00"
    if ensure_even_bytes:
        if len(str_bytes) % 2 == 0:
            return str_bytes
        else:
            return str_bytes + b"\x00"
    return str_bytes


def search_sublist(str_id_list: list, search_id: int):
    """
    Searches a list of lists for a matching search_id, then
    returns the first index in the list. This is intended to be used
    with version 4 files where we can find string ids that share the same offset,
    returning the string ids that are associated with an offset.

    :param str_id_list: List of string ids that you want to query
    :param search_id: The id to search for in the str_id_list
    :returns: Associated string ids.
    """
    for sublist in str_id_list:
        if search_id in sublist:
            return sublist


def build_string_table_1(json_list: list):
    """
    Builds a string table from json_list for version 1 files.
    Returns a list of the translated bytes to write to the string table
    and the new offset to write to the indx table.
    Return ex: {"114": {"str": "\x01\x03\x03\x05", new_offset: "\x01\xAB\x01\x00"}}
    In this example, "114" is the original offset to look up from the original file.
    """
    final_bytes = bytearray()
    offset_data = {}
    for str_id in json_list:
        # en = json_list[str_id]['en'] #KwK
        language = json_list[str_id][args.pack_all_language] #KwK
        # print(f"language = {language}") #KwK
        ja = json_list[str_id]['ja'] #KwK
        # ja, en = next(iter(json_list[str_id].items()))
        if language == "":
            # use the ja string, no translation
            str_bytes = bytes(ja, encoding="utf-8") + b"\x00"
        else:
            # use the en string, it's translated
            str_bytes = bytes(language, encoding="utf-8") + b"\x00"
        # ensures the string (including NTs) has an even number of bytes
        if len(str_bytes) % 2 != 0:
            str_bytes += b"\x00"
        if final_bytes:
            # shifts the offset by one
            new_offset = int(len(final_bytes) / 2 + 1)
        else:
            # v1 files start at offset 1
            new_offset = 1
        final_bytes += str_bytes
        offset = {
            "str": str_bytes,
            "new_offset": new_offset
        }
        offset_data[str_id] = offset
    return offset_data, final_bytes


def build_string_table_4(json_list: list, dupe_string_list: list):
    """
    Builds a string table from json_list for version 4 files.
    Returns a list of the translated bytes to write to the string table
    and the new offset to write to the indx table.
    Return ex: {"114": {"str": "\x01\x03\x03\x05", new_offset: "\x01\xAB\x01\x00"}}
    In this example, "114" is the original offset to look up from the original file.
    """
    final_bytes = bytearray()
    offset_data = {}
    for str_id in json_list:
        find_dupes = search_sublist(str_id_list=dupe_string_list, search_id=int(str_id))

        # if there are multiple string ids that share the same offset,
        # we want to check if this is the primary (first) match. if not,
        # all other string ids in the list are going to reference the first
        # occurrence. we don't want to add the dupes to the text table, so
        # just map the existing offset. 
        if len(find_dupes) > 1 and int(str_id) != find_dupes[0]:
            str_bytes = b""
            new_offset = offset_data[str(find_dupes[0])]["new_offset"]
        else:
            # en = json_list[str_id]['en'] #KwK
            language = json_list[str_id][args.pack_all_language] #KwK
            # print(f"language = {language}") #KwK
            ja = json_list[str_id]['ja'] #KwK
            # ja, en = next(iter(json_list[str_id].items()))
            if language == "":
                # use the ja string, no translation
                str_bytes = bytes(ja, encoding="utf-8") + b"\x00"
            else:
                # use the en string, it's translated
                str_bytes = bytes(language, encoding="utf-8") + b"\x00"
            # ensures the string (including NTs) has an even number of bytes
            if len(str_bytes) % 2 != 0:
                str_bytes += b"\x00"
            if final_bytes:
                new_offset = int(len(final_bytes) / 2)
            else:
                new_offset = 0
            final_bytes += str_bytes

        offset = {
            "str": str_bytes,
            "new_offset": new_offset
        }
        offset_data[str_id] = offset

    return offset_data, final_bytes


def recalculate_headers(file_obj: object):
    "Update header lengths and add FOOTs to end of file."
    # update TEXT sizing
    file_obj.seek(88)
    indx_size = unpack_uint(file_obj.read(4))
    file_obj.read(4)  # read passed padding
    file_obj.read(indx_size)
    file_obj.read(16)  # read passed FOOT
    file_obj.read(16)  # read passed TEXT
    text_start = file_obj.tell()
    text_end = file_obj.seek(0, 2)
    text_size = text_end - text_start
    file_obj.seek(text_start - 16 + 8)  # -16 to get to beginning of TEXT and +8 to jump to size. easier to read this way
    file_obj.write(pack_uint(text_size) + b"\x00\x00\x00\x00")
    file_obj.seek(0, 2)
    write_foot(file_obj=file_obj)

    # calculate new size for blja header
    file_obj.seek(80)
    blja_start = file_obj.tell()
    file_obj.seek(0, 2)
    blja_end = file_obj.tell()
    blja_size = blja_end - blja_start
    file_obj.seek(72)
    file_obj.write(pack_uint(blja_size))
    file_obj.seek(0, 2)
    write_foot(file_obj=file_obj)

    # calculate new size for evtx header
    file_obj.seek(16)
    evtx_start = file_obj.tell()
    file_obj.seek(0, 2)
    evtx_end = file_obj.tell()
    evtx_size = evtx_end - evtx_start
    file_obj.seek(8)
    file_obj.write(pack_uint(evtx_size))
    file_obj.seek(0, 2)
    write_foot(file_obj=file_obj)


def build_etp_0_2(json_list: list, src_etp: str):
    "Builds an ETP file for file versions 0 and 2."
    # grab original file header data we'll copy over to new file
    with open(src_etp, "rb") as f:
        orig_etp_data = f.read(96)
        indx_size = unpack_uint(orig_etp_data[88:92])
        indx_start = f.tell()
        orig_indx_table = f.read(indx_size)
        f.read(32)  # skip passed foot + text
        text_start = f.tell()

    etp_file = os.path.basename(src_etp)
    # with open(f"new_etp/{etp_file}", "w+b") as etp_f:
    # with open(f"new_etp/ETP_{args.pack_all_language}/{etp_file}", "w+b") as etp_f: #KwK
    with open(f"../../../staging/{args.pack_all_language}/Game/Content/NonAssets/ETP/{etp_file}", "w+b") as etp_f: #KwK
        etp_f.write(orig_etp_data)
        etp_f.write(orig_indx_table)
        write_foot(file_obj=etp_f)
        write_text(file_obj=etp_f)
        curr_indx_pos = 0
        # iterate over indx entries in table
        for string_id, offset in iter_unpack("<I I", orig_indx_table):
            if string_id == 0:
                continue
            # update the indx entry first. we figure out where this is by jumping to the end
            # of the file, grabbing its position and subtracting it with the initial text start.
            text_offset = etp_f.seek(0, 2) - text_start # seek to end of file to get offset
            etp_f.seek(indx_start + curr_indx_pos + 4) # jump passed string_id and get to text offset
            etp_f.write(pack_uint(text_offset)) # update the new offset
            etp_f.seek(0, 2) # position pointer back to end of file to write text
            string_bytes = get_string_bytes(json_list=json_list, search_key=str(string_id))
            if not string_bytes:
                sys.exit(f"Cannot build ETP. Unable to find key {offset} in json file.")
            etp_f.write(string_bytes)
            curr_indx_pos += 8
        align_file(file_obj=etp_f, alignment=16)
        recalculate_headers(file_obj=etp_f)


def build_etp_1(json_list: list, src_etp: str):
    "Builds an ETP file for file version 1."
    with open(src_etp, "rb") as f:
        orig_etp_data = f.read(96)
        offset_count = unpack_uint(orig_etp_data[44:48])  # get from cmnh
        indx_size = unpack_uint(orig_etp_data[88:92])
        orig_indx_table = f.read(indx_size)
        offset_table_size = unpack_ushort(orig_indx_table[2:4])

    etp_file = os.path.basename(src_etp)
    # with open(f"new_etp/{etp_file}", "w+b") as etp_f:
    # with open(f"new_etp/ETP_{args.pack_all_language}/{etp_file}", "w+b") as etp_f: #KwK
    with open(f"../../../staging/{args.pack_all_language}/Game/Content/NonAssets/ETP/{etp_file}", "w+b") as etp_f: #KwK
        # write beginning of file
        etp_f.write(orig_etp_data)
        etp_f.write(orig_indx_table[:20])

        # first, we need to build our new string table.
        str_table, str_bytes = build_string_table_1(
            json_list=json_list,
        )

        # now we need to read the existing offset table, find the original offset in the
        # new str_table, grab the new offset we generated and write it here.
        iterate = 0
        orig_indx_pos = 20  # first offset is 20 bytes in
        wrote_offset_divider = False
        end_of_short_pos = 0
        wrote_cdab = False

        etp_f.seek(0, 2)
        while iterate < offset_table_size:
            offset = unpack_ushort(orig_indx_table[orig_indx_pos:orig_indx_pos+2])
            if offset == 0:
                if not wrote_offset_divider:
                    etp_f.write(b"\x00\x00")
                else:
                    etp_f.write(b"\x00\x00\x00\x00")
                orig_indx_pos += 2
                iterate += 1
                continue

            result = str_table[str(offset)]
            # write in shorts until we encounter our first uint
            if result["new_offset"] <= 65535 and not wrote_offset_divider:
                new_offset = pack_ushort(result["new_offset"])
            else:
                # hit our first uint. split the table up
                if not wrote_offset_divider:
                    end_of_short_pos = etp_f.tell()
                    if etp_f.tell() % 4 != 0:
                        end_of_short_pos = f.tell()
                        etp_f.write(b"\xCD\xAB")
                        wrote_cdab = True
                    wrote_offset_divider = True
                # hit an int that is too large to fit in a short. this table
                # will have a 4 byte offset section in the indx table going forward.
                new_offset = pack_uint(result["new_offset"])
            etp_f.write(new_offset)

            orig_indx_pos += 2
            iterate += 1

        # if we still have offsets in the original file left, we need to read them
        # as uints instead of ushorts.
        if iterate != offset_count:
            # check if we need to skip over cdab bytes in original table
            if orig_indx_table[orig_indx_pos:orig_indx_pos+2] == b"\xCD\xAB":
                orig_indx_pos += 2

            # iterate over remaining offsets in table
            while iterate != offset_count:
                offset = unpack_uint(orig_indx_table[orig_indx_pos:orig_indx_pos+4])
                if offset == 0:
                    if not wrote_offset_divider:
                        etp_f.write(b"\x00\x00")
                    else:
                        etp_f.write(b"\x00\x00\x00\x00")
                    orig_indx_pos += 4
                    iterate += 1
                    continue

                result = str_table[str(offset)]
                # write in shorts until we encounter our first uint
                if result["new_offset"] <= 65535 and not wrote_offset_divider:
                    new_offset = pack_ushort(result["new_offset"])
                else:
                    # hit our first uint. split the table up
                    if not wrote_offset_divider:
                        end_of_short_pos = etp_f.tell()
                        if etp_f.tell() % 4 != 0:
                            etp_f.write(b"\xCD\xAB")
                            wrote_cdab = True
                        wrote_offset_divider = True
                    # hit an int that is too large to fit in a short. this table
                    # will have a 4 byte offset section in the indx table going forward.
                    new_offset = pack_uint(result["new_offset"])
                etp_f.write(new_offset)
                orig_indx_pos += 4
                iterate += 1

        # need to track the short offset table size to update the data inside of the indx table
        if end_of_short_pos == 0:
            end_of_short_pos = etp_f.tell()

        # add cdab if current eof isn't in 4 byte increments
        if etp_f.tell() % 4 != 0:
            etp_f.write(b"\xCD\xAB")
            wrote_cdab = True
        align_file(file_obj=etp_f, alignment=16)
        end_of_indx = etp_f.tell()

        # update the value of the short table. if there is a "cd ab" value,
        # don't include this in the calculation
        etp_f.seek(98)
        etp_f.write(pack_uint(int((end_of_short_pos - 116) / 2)))  # -116 to remove everything up to where offset starts

        # update the value of the entire INDX section up to the end of the short
        # table. if there is a "cd ab" value, DO include this in the calculation.
        etp_f.seek(112)
        short_len = end_of_short_pos - 96  # -96 to remove everything up until start of indx
        if wrote_cdab:
            short_len += 2
        etp_f.write(pack_uint(short_len))

        new_indx_size = end_of_indx - 96
        etp_f.seek(88)
        etp_f.write(pack_uint(new_indx_size) + b"\x00\x00\x00\x00")
        etp_f.seek(0, 2)
        write_foot(file_obj=etp_f)
        write_text(file_obj=etp_f)
        etp_f.write(b"\x00\x00")  # first offset is always 0
        etp_f.write(str_bytes)
        align_file(file_obj=etp_f, alignment=16)
        recalculate_headers(file_obj=etp_f)


def get_duplicate_offsets_4(src_etp: str):
    basename = os.path.basename(src_etp)
    with open(f"../dump_etps/etps/{basename}", "rb") as f:
        # get string table information
        indx_start = 96
        f.seek(indx_start)
        string_table_size = unpack("<H", f.read(2))[0]

        # get offset table information
        string_table_start = 116
        f.seek(string_table_start)
        f.seek((string_table_size * 2), 1)
        offset_table_start = f.tell()
        if offset_table_start % 4 != 0:
            offset_table_start += 2

        # short offset information
        f.seek(112)
        short_offset_end = unpack("<I", f.read(4))[0] + indx_start  # get exact file pos by adding indx_start

        # iterate over string ids
        str_pos = string_table_start
        off_pos = offset_table_start
        ushort = 2
        uint = 4
        offset_dict = {}
        for i in range(0, string_table_size):
            f.seek(str_pos)
            str_id = unpack("<H", f.read(2))[0]
            f.seek(off_pos)

            if f.tell() < short_offset_end:
                # if we encounter a table split in the offset table, skip over it
                # and read as a uint. otherwise, reset the file pointer.
                if f.read(2) != b"\xCD\xAB":
                    f.seek(-2, 1)
                    offset = unpack("<H", f.read(ushort))[0]
                    off_pos += ushort
                else:
                    offset = unpack("<I", f.read(uint))[0]
                    off_pos += uint + 2  # add the "CD AB" bytes we ignored
            else:
                offset = unpack("<I", f.read(uint))[0]
                off_pos += uint

            # associate offset <-> str_id to find duplicates
            if offset_dict.get(offset):
                offset_dict[offset] += [str_id]
            else:
                offset_dict[offset] = [str_id]

            str_pos += ushort

        # the offsets themselves are irrelevant for packing because our data will have
        # different offsets, so just group the string ids together to get the duplicates.
        offset_list = []
        for offset in offset_dict:
            offset_list.append(offset_dict[offset])

        return offset_list


def build_etp_4(json_list: list, src_etp: str):
    "Builds an ETP file for file version 4."
    with open(src_etp, "rb") as f:
        orig_etp_data = f.read(116)
        indx_size = unpack("<I", orig_etp_data[88:92])[0]
        str_table_size = unpack("<H", orig_etp_data[96:98])[0] * 2
        f.seek(96)  # go back to beginning of indx table
        orig_indx_table = f.read(indx_size)

    etp_file = os.path.basename(src_etp)
    # with open(f"new_etp/{etp_file}", "w+b") as etp_f:
    # with open(f"new_etp/ETP_{args.pack_all_language}/{etp_file}", "w+b") as etp_f: #KwK
    with open(f"../../../staging/{args.pack_all_language}/Game/Content/NonAssets/ETP/{etp_file}", "w+b") as etp_f: #KwK
        # write beginning of file
        etp_f.write(orig_etp_data)

        # first, we need to build our new string table.
        dupe_string_list = get_duplicate_offsets_4(src_etp)
        text_tables = build_string_table_4(json_list=json_list, dupe_string_list=dupe_string_list)
        str_text = text_tables[0]
        str_bytes = text_tables[1]

        # now we need to read the existing offset table, find the original offset in the
        # new str_table, grab the new offset we generated and write it here.
        orig_current_pos = 20
        string_table = orig_indx_table[orig_current_pos:orig_current_pos+str_table_size]

        # write string table to file
        etp_f.write(string_table)

        # if table is not 4 byte aligned, need to add "CD AB" bytes
        if etp_f.tell() % 4 != 0:
            etp_f.write(b"\xCD\xAB")

        # iterate over string table
        wrote_offset_divider = False
        strings_written = 0
        short_offset_start = etp_f.tell()
        short_offset_end = 0
        wrote_cdab = False
        for s_id in iter_unpack("<H", string_table):
            find_dupe = search_sublist(str_id_list=dupe_string_list, search_id=s_id[0])[0]
            result = str_text[str(find_dupe)]

            # write in shorts until we encounter our first uint
            if result["new_offset"] <= 65535 and not wrote_offset_divider:
                new_offset = pack_ushort(result["new_offset"])
                etp_f.write(new_offset)
                strings_written += 1
            else:
                # hit our first uint. split the table up
                if not wrote_offset_divider:
                    short_offset_end = etp_f.tell()
                    if etp_f.tell() % 4 != 0:
                        etp_f.write(b"\xCD\xAB")
                        wrote_cdab = True
                    wrote_offset_divider = True
                # hit an int that is too large to fit in a short. this table
                # will have a 4 byte offset section in the indx table.
                new_offset = pack_uint(result["new_offset"])
                etp_f.write(new_offset)
                strings_written += 1

        # if table is not 4 byte aligned, need to add "CD AB" bytes to make it so
        etp_f.seek(0, 2)
        if etp_f.tell() % 4 != 0:
            etp_f.write(b"\xCD\xAB")

        if not short_offset_end:
            short_offset_end = etp_f.tell()

        align_file(file_obj=etp_f, alignment=16)
        end_of_indx = etp_f.tell()

        # update short offset table size
        short_offset_size = int((short_offset_end - short_offset_start) / 2)
        etp_f.seek(98)
        etp_f.write(pack_ushort(short_offset_size))

        # update string id + short offset table total size
        # the cdab bytes must be included in the total size
        if wrote_offset_divider and wrote_cdab:
            short_offset_end += 2
        total_str_id_off_size = (short_offset_end - 96)  # chop off beginning file bytes up until string_ids start
        etp_f.seek(112)
        etp_f.write(pack_uint(total_str_id_off_size))

        new_indx_size = end_of_indx - 96
        etp_f.seek(88)
        etp_f.write(pack_uint(new_indx_size) + b"\x00\x00\x00\x00")
        etp_f.seek(0, 2)
        write_foot(file_obj=etp_f)
        write_text(file_obj=etp_f)
        etp_f.write(str_bytes)
        align_file(file_obj=etp_f, alignment=16)
        recalculate_headers(file_obj=etp_f)
        if (str_table_size / 2) != strings_written:
            print(f"ERROR: File {etp_file} did not write correct amount of strings. Expected: {str_table_size / 2}, Actual: {strings_written}")


def build_etp(json_file: list, src_etp: str):
    file_version = determine_etp_version(file=src_etp)
    etp_json = read_json_file(file=json_file)
    if file_version in [0, 2]:
        data = build_etp_0_2(json_list=etp_json, src_etp=src_etp)
    elif file_version == 1:
        data = build_etp_1(json_list=etp_json, src_etp=src_etp)
    elif file_version == 4:
        data = build_etp_4(json_list=etp_json, src_etp=src_etp)
    elif not file_version:
        print("Not an ETP file.")
    else:
        print(f"ETP version \"{file_version}\" is not currently supported.")

def build_all():
########################################################################################################################################################################################################
#    # json_files = glob.glob("new_json/en/*.json")
#    json_files = glob.glob("../dump_etps/AppID_1358750/BuildID_14529657/BACKLOG/pakchunk0-{PLATFORM}.pak/Game/Content/NonAssets/ETP/*.json") #KwK
#    for json_file in json_files:
#        etp = os.path.basename(json_file).replace(".json", ".etp")
#        print(f"Packing {etp}.")
#        # etp_file = f"../dump_etps/etps/{etp}"
#        etp_file = f"../dump_etps/AppID_1358750/BuildID_14529657/REFERENCES/pakchunk0-{{PLATFORM}}.pak/Game/Content/NonAssets/ETP/{etp}" #KwK, double curly-braces to escape it
#        build_etp(json_file=json_file, src_etp=etp_file)
########################################################################################################################################################################################################
    # json_files = glob.glob("new_json/en/*.json")
    # json_files = glob.glob("../../../dqx-offline-localization/BACKLOG/pakchunk0-Switch_P/Holiday/Content/NonAssets/ETP/*.json") #KwK, old format
    json_files = glob.glob("../../../dqx-offline-localization/Steam/App_ID-1358750/Build_ID-14529657/BACKLOG/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/ETP/*.json") #KwK, new format
    for json_file in json_files:
        try:
            etp = os.path.basename(json_file).replace(".json", ".etp")
            # etp_file = f"../dump_etps/etps/{etp}"
            etp_file = f"../dump_etps/AppID_1358750/BuildID_14529657/REFERENCES/pakchunk0-{{PLATFORM}}.pak/Game/Content/NonAssets/ETP/{etp}" #KwK, double curly-braces to escape it
            build_etp(json_file=json_file, src_etp=etp_file)
            print(f"\033[32m Packed (ETP_{args.pack_all_language}) {etp}.\033[0m") #KwK
        except Exception as e:
            print(f"\033[31m{json_file}\nError At:{e}\033[0m") #KwK

    json_files = glob.glob("../../../dqx-offline-localization/Steam/App_ID-1358750/Build_ID-14529657/IN_PROGRESS/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/ETP/*.json") #KwK, new format
    for json_file in json_files:
        try:
            etp = os.path.basename(json_file).replace(".json", ".etp")
            # etp_file = f"../dump_etps/etps/{etp}"
            etp_file = f"../dump_etps/AppID_1358750/BuildID_14529657/REFERENCES/pakchunk0-{{PLATFORM}}.pak/Game/Content/NonAssets/ETP/{etp}" #KwK, double curly-braces to escape it
            build_etp(json_file=json_file, src_etp=etp_file)
            print(f"\033[32m Packed (ETP_{args.pack_all_language}) {etp}.\033[0m") #KwK
        except Exception as e:
            print(f"\033[31m{json_file}\nError At:{e}\033[0m") #KwK

    # json_files = glob.glob("../../../dqx-offline-localization/BACKLOG/pakchunk0-Switch_P/Holiday/Content/NonAssets/ETP/*.json") #KwK, old format
    json_files = glob.glob("../../../dqx-offline-localization/Steam/App_ID-1358750/Build_ID-14529657/DONE/pakchunk0-WindowsNoEditor.pak/Game/Content/NonAssets/ETP/*.json") #KwK, new format
    for json_file in json_files:
        try:
            etp = os.path.basename(json_file).replace(".json", ".etp")
            # etp_file = f"../dump_etps/etps/{etp}"
            etp_file = f"../dump_etps/AppID_1358750/BuildID_14529657/REFERENCES/pakchunk0-{{PLATFORM}}.pak/Game/Content/NonAssets/ETP/{etp}" #KwK, double curly-braces to escape it
            build_etp(json_file=json_file, src_etp=etp_file)
            print(f"\033[32m Packed (ETP_{args.pack_all_language}) {etp}.\033[0m") #KwK
        except Exception as e:
            print(f"\033[31m{json_file}\nError At:{e}\033[0m") #KwK
########################################################################################################################################################################################################
#    json_files = glob.glob("../../../dqx-offline-localization/FINAL/pakchunk0-Switch_P/Holiday/Content/NonAssets/ETP/*.json") #KwK
#    for json_file in json_files:
#        try: #KwK
#            etp = os.path.basename(json_file).replace(".json", ".etp")
#            etp_file = f"../dump_etps/etps/{etp}"
#            build_etp(json_file=json_file, src_etp=etp_file)
#            print(f"\033[32m Packed {etp}.\033[0m") #KwK
#        except Exception as e: #KwK
#            print(f"\033[31m{json_file}\nError At:{e}\033[0m") #KwK
########################################################################################################################################################################################################

def recrypt_file(file: str):
    db_path = "../import_sql/dat_db.db"
    db_conn = sqlite3.connect(db_path)
    db_cur = db_conn.cursor()
    file = os.path.basename(file)
    encrypted_file = db_cur.execute(f"SELECT file, blowfish_key from files WHERE blowfish_key IS NOT NULL AND file = \"{file}\"")
    result = encrypted_file.fetchone()
    if result:
        # if os.path.exists(f"new_etp/{file}"):
        # if os.path.exists(f"new_etp/ETP_{args.pack_all_language}/{file}"): #KwK
        if os.path.exists(f"../../../staging/{args.pack_all_language}/Game/Content/NonAssets/ETP/{file}"): #KwK
            agent = attach_client()
            # encrypt(agent=agent, filepath=f"new_etp/{file}", encryption_key=result[1])
            # encrypt(agent=agent, filepath=f"new_etp/ETP_{args.pack_all_language}/{file}", encryption_key=result[1]) #KwK
            encrypt(agent=agent, filepath=f"../../../staging/{args.pack_all_language}/Game/Content/NonAssets/ETP/{file}", encryption_key=result[1]) #KwK
            # os.replace(src=f"new_etp/{file}.enc", dst=f"new_etp/{file}")
            # os.replace(src=f"new_etp/ETP_{args.pack_all_language}/{file}.enc", dst=f"new_etp/ETP_{args.pack_all_language}/{file}") #KwK
            os.replace(src=f"../../../staging/{args.pack_all_language}/Game/Content/NonAssets/ETP/{file}.enc", dst=f"../../../staging/{args.pack_all_language}/Game/Content/NonAssets/ETP/{file}") #KwK
            agent.detach_game()
    else:
        print(f"{file} was either not originally encrypted or there isn't a stored blowfish key for it in the database.")


def recrypt_files():
    db_path = "../import_sql/dat_db.db"
    db_conn = sqlite3.connect(db_path)
    db_cur = db_conn.cursor()
    encrypted_files = db_cur.execute(f"SELECT file, blowfish_key from files WHERE blowfish_key IS NOT NULL")
    for file in encrypted_files.fetchall():
        etp_file = file[0]
        recrypt_file(etp_file)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Read a JSON file dumped by this program and rebuild into an ETP file.")
    parser.add_argument("-e", "--etp-file", type=str, help="Path to ETP file.")
    parser.add_argument("-j", "--json-file", type=str, help="Path to translated JSON file.")
    parser.add_argument("-a", "--pack-all", default=False, action="store_true", help="Pack all JSON files dumped by this program into ETP. Before using this flag, ensure you haven't changed any names.")
    parser.add_argument("-L", "--pack-all-language", type=str, help="Language to translate [br-pt,de,en,es,fr,it,ja,ko,zh-hans,zh-hant].") #KwK
    parser.add_argument("-r", "--recrypt", default=False, action="store_true", help="Recrypt files. DQX must be open. This only works when used with (-e and -j) or (-a).")
    args = parser.parse_args(args=None if sys.argv[1:] else ["--help"])

    # os.makedirs("new_etp", exist_ok=True)
    # os.makedirs(f"new_etp/ETP_{args.pack_all_language}", exist_ok=True) #KwK
    os.makedirs(f"../../../staging/{args.pack_all_language}/Game/Content/NonAssets/ETP", exist_ok=True) #KwK

    if args.pack_all:
        build_all()
        if args.recrypt:
            recrypt_files()
    elif args.pack_all_language:
        # print(f"pack all {args.pack_all_language}") #KwK
        build_all()
        if args.recrypt:
            recrypt_files()
    else:
        if not (args.etp_file and args.json_file):
            parser.print_help()
            sys.exit(1)
        build_etp(json_file=args.json_file, src_etp=args.etp_file)
        if args.recrypt:
            file = os.path.basename(args.etp_file)
            # recrypt_file(file=f"new_etp/{file}")
            # recrypt_file(file=f"new_etp/ETP_{args.pack_all_language}/{file}") #KwK
            recrypt_file(file=f"../../../staging/{args.pack_all_language}/Game/Content/NonAssets/ETP/{file}") #KwK
