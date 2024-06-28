/*
PREREQUISITES:
npm init -y
*/

import fs from 'fs';

let ETP = `ETP`
let ETP_ko = `ETP_ko`
let ETP_zh_hans = `ETP_zh_hans`
let ETP_zh_hant = `ETP_zh_hant`
let array = [ETP, ETP_ko, ETP_zh_hans, ETP_zh_hant]

for (const v of array.values()) {

	fs.mkdir(`./sorted/${v}`, { recursive: true }, (err) => { if (err) throw err; })

	fs.readdir(v, (err, files) => {

		files.forEach(file => {

			fs.readFile(`./${v}/${file}`, function (error, content) {

				var data = JSON.parse(content);

				let newData = Object.entries(data).sort(function (a, b) { return a - b; });

				fs.writeFile(`./sorted/${v}/${file}`, JSON.stringify(data, newData + newData, 2), (err) => {
					if (err)
						console.log(`\x1b[31m`+err+`\x1b[0m`);
					else {
						console.log(`\x1b[32m'./sorted/${v}/${file}' \x1b[34msuccessfully written!\x1b[0m`)
					}
				})
			});
		})
	});
};
