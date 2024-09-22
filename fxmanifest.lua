fx_version('cerulean')
games({ 'gta5' })
lua54 'yes'

author 'Newcore framework - K1anFromDK'

shared_scripts {
    '@ox_lib/init.lua',
    'shared.lua',
}

server_scripts({
    '@oxmysql/lib/MySQL.lua',
    'server/**.lua',
});

client_scripts({
    'client/**.lua',
});

dependencies {
    'nc-core',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/script.js',
    'web/style.css',
}
