import { environment }  from './../environments/environment';

export const applicationConfig = {
    appName: 'Lingua::Poly',
    availableLocales: ['en'],
    defaultLocale: ['en'],
    defaultCountry: ['US']
};

export class ApiEndpoint {
    protected constructor(
        public url: string,
        public params: any,
        public auth: boolean
    ) {}

    static of(url: string,  params: any,  auth: boolean) {
        return new ApiEndpoint(url, params, auth);
    }

    getURL() {
        let url = this.url;
        
        if (this.params)
            for (const inx in this.params)
                if (this.params.hasOwnProperty(inx))
                    url = url.replace('{' + inx + '}', this.params[inx]);

        return url;
    }
}

export const ApiEndpoints = {
    auth: {
        login: (params: any = null) => ApiEndpoint.of(
            'user/login', 
             params, 
             false),
    }
}
