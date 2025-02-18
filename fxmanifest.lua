fx_version 'cerulean'
game 'gta5'

name 'life-selector'
author 'kyle'
version '1.0.0'
description 'Life Selector for FiveM'

shared_scripts {
    'require.lua',
    'init.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'shared/*.lua',
    'modules/interface/client.lua',
    'modules/utility/shared/*.lua',
    'modules/paths/client.lua'
}

lua54 'yes'
use_experimental_fxv2_oal 'yes'