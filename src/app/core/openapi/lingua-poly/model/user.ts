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
import { UserAllOf } from './userAllOf';
import { Profile } from './profile';


/**
 * A user object with private information included.
 */
export interface User { 
    /**
     * How the user\'s  name gets displayed.
     */
    username?: string;
    /**
     * The user\'s web presence.
     */
    homepage?: string;
    /**
     * Mini bio or additional information
     */
    description?: string;
    /**
     * The user\'s email address.
     */
    email?: string;
}

