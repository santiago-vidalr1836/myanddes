export const environment = {
    baseUrl:'https://myanddes.anddes.com:8443/',
    msalConfig: {
        auth: {
            clientId: '2f93afcf-7018-48cf-9ac3-f22dd3f21a5f',
            authority: 'https://login.microsoftonline.com/2e7c2c87-0ed1-48f9-a17a-76261219bf54',
            redirectUrl:'https://myanddes.anddes.com/home'
        }
    },
    apiConfig: {
        scopes: ['user.read'],
        uri: 'https://graph.microsoft.com/v1.0/me'
    }
};
