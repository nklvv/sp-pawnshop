fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Trangerr'
description 'Pawnshop'
version '1.0.0'

shared_script {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_script 'client/cl_main.lua'
server_script 'server/sv_main.lua'