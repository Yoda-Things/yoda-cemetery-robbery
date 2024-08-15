fx_version('cerulean')

games({ 'gta5' })

lua54 'yes'

author 'YODDA THINGS (Diogo)'
description 'Cemetery Robbery'
version '1.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/**',
}

server_scripts {
    'server/**',
}

client_scripts {
    'client/**',
}

files {
    'locales/**',
}