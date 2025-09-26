export const environment = {
    production: true,
    baseUrl:'http://localhost:8080/',
    baseUrl_:'https://myanddes.anddes.com:8443/',
    msalConfig: {
        auth: {
            clientId: '47d51745-c58d-496a-9c9e-7bd84b8f3850',
            authority: 'https://login.microsoftonline.com/8200d982-c551-4dd5-8dc7-2d649035f4f3',
            redirectUrl:'http://localhost:4200/home'
        }
    },
    apiConfig: {
        scopes: ['user.read'],
        uri: 'https://graph.microsoft.com/v1.0/me'
    }
};
