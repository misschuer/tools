#pragma once
#ifndef _SENSITIVE_CHECKER_H
#define _SENSITIVE_CHECKER_H
#include <lua.hpp>
#include <string.h>

#define kind 256
#define maxn 200001

extern "C" {
	int luaopen_libchecker(lua_State *L);
}

#endif
