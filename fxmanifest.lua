fx_version 'cerulean'
game 'gta5'

author 'dugan6666'
description 'Advanced car rental script'
version 'v0.1'

shared_scripts {
	'@qb-core/shared/locale.lua',
    'locales/*.lua',
	'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*'
}

client_script 'client/*'


lua54 'yes'