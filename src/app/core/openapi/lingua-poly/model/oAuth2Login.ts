/**
 * Lingua::Poly OpenAPI WebApp
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * The version of the OpenAPI document: 1.0
 * 
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */


export interface OAuth2Login { 
    /**
     * Opaque name of an OAuth2 provider
     */
    provider: OAuth2Login.ProviderEnum;
    token: string;
}
export namespace OAuth2Login {
    export type ProviderEnum = 'FACEBOOK' | 'GOOGLE';
    export const ProviderEnum = {
        FACEBOOK: 'FACEBOOK' as ProviderEnum,
        GOOGLE: 'GOOGLE' as ProviderEnum
    };
}

