/* Copyright Reflection Contributors 2024-2026 */

#pragma once

bool CanImport(const FString& Type, const bool IsCloud = false, const UClass* Class = nullptr);

/* Whether a class is finished enough to be built on: one that never came across has no constructor and the engine asserts on it */
bool ClassIsFormed(const UClass* Class);