--
-- Created by IntelliJ IDEA.  Copyright (C) 2017 Hanks
-- User: hanks
-- Date: 2017/5/2
-- Time: 14:24
--
local require = require
local table = require "table"
local packages = {}
local loaded = {}
luajava.package = packages
luajava.loaded = loaded
bindClass = luajava.bindClass
local insert = table.insert
local new = luajava.new

local _G = {}

local luacontext = activity or service
local ViewGroup = bindClass("android.view.ViewGroup")
local String = bindClass("java.lang.String")
local Gravity = bindClass("android.view.Gravity")
local OnClickListener = bindClass("android.view.View$OnClickListener")
local TypedValue = bindClass("android.util.TypedValue")
local BitmapDrawable = bindClass("android.graphics.drawable.BitmapDrawable")
local ArrayAdapter = bindClass("android.widget.ArrayAdapter")
local android_R = bindClass("android.R")
android = { R = android_R }

local Object = bindClass("java.lang.Object")

local context = activity
if service then
    context = service.getApplicationContext()
end


local globalMT = {
    __index = function(T, classname)
        for i, p in ipairs(loaders) do
            local class = loaded[classname] or p(classname)
            if class then
                T[classname] = class
                return class
            end
        end
        return nil
    end
}

local pkgMT = {
    __index = function(T, classname)
        local ret, class = pcall(bindClass, rawget(T, "__name") .. classname)
        if ret then
            rawset(T, classname, class)
            return class
        else
            error(classname .. " is not in " .. rawget(T, "__name"), 2)
        end
    end
}

local function import_class(classname, packagename)
    packagename = massage_classname(packagename)
    local res, class = pcall(bindClass, packagename)
    if res then
        loaded[classname] = class
        return class
    end
end

local function import_dex_class(classname, packagename)
    packagename = massage_classname(packagename)
    for _, dex in ipairs(dexes) do
        local res, class = pcall(dex.loadClass, packagename)
        if res then
            loaded[classname] = class
            return class
        end
    end
end

local function import_pacckage(packagename)
    local pkg = { __name = packagename }
    setmetatable(pkg, pkgMT)
    return pkg
end

local function append(t,v)
    for _,_v in ipairs(t) do
        if _v==v then
            return
        end
    end
    insert(t,v)
end


local function import_require(name)
    local s, r = pcall(require, name)
    if not s and not r:find("no file") then
        error(r, 0)
    end
    return s and r
end

local function env_import(env)
    local _env = env
    setmetatable(_env, globalMT)
    return function(package)
        local j = package:find(':')
        if j then
            local dexname = package:sub(1, j - 1)
            local classname = package:sub(j + 1, -1)
            local class = luacontext.loadDex(dexname).loadClass(classname)
            local classname = package:match('([%w_]+)$')
            _env[classname] = class
            return class
        end
        local i = package:find('%*$')
        if i then -- a wildcard; put into the package list, including the final '.'
            append(packages, package:sub(1, -2))
            return import_pacckage(package:sub(1, -2))
        else
            local classname = package:match('([%w_]+)$')
            local class = import_require(package) or import_class(classname, package) or import_dex_class(classname, package)
            if class then
                if class ~= true then
                    --findtable(package)=class
                    _env[classname] = class
                end
                return class
            else
                error("cannot find " .. package, 2)
            end
        end
    end
end

import = env_import(_G)

return _G

