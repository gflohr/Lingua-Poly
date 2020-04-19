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
/* tslint:disable:no-unused-variable member-ordering */

import { Inject, Injectable, Optional }                      from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams,
         HttpResponse, HttpEvent, HttpParameterCodec }       from '@angular/common/http';
import { CustomHttpParameterCodec }                          from '../encoder';
import { Observable }                                        from 'rxjs';

import { PasswordChange } from '../model/passwordChange';
import { PasswordReset } from '../model/passwordReset';
import { Problem } from '../model/problem';
import { Profile } from '../model/profile';
import { Token } from '../model/token';
import { User } from '../model/user';
import { UserDraft } from '../model/userDraft';
import { UserLogin } from '../model/userLogin';

import { BASE_PATH, COLLECTION_FORMATS }                     from '../variables';
import { Configuration }                                     from '../configuration';


@Injectable({
  providedIn: 'root'
})
export class UsersService {

    protected basePath = 'http://localhost:4200/api/lingua-poly/users/v1';
    public defaultHeaders = new HttpHeaders();
    public configuration = new Configuration();
    public encoder: HttpParameterCodec;

    constructor(protected httpClient: HttpClient, @Optional()@Inject(BASE_PATH) basePath: string, @Optional() configuration: Configuration) {
        if (configuration) {
            this.configuration = configuration;
        }
        if (typeof this.configuration.basePath !== 'string') {
            if (typeof basePath !== 'string') {
                basePath = this.basePath;
            }
            this.configuration.basePath = basePath;
        }
        this.encoder = this.configuration.encoder || new CustomHttpParameterCodec();
    }



    /**
     * Get public parts of foreign user profile
     * @param name The username
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public getUserByName(name: string, observe?: 'body', reportProgress?: boolean): Observable<Profile>;
    public getUserByName(name: string, observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<Profile>>;
    public getUserByName(name: string, observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<Profile>>;
    public getUserByName(name: string, observe: any = 'body', reportProgress: boolean = false ): Observable<any> {
        if (name === null || name === undefined) {
            throw new Error('Required parameter name was null or undefined when calling getUserByName.');
        }

        let headers = this.defaultHeaders;

        // authentication (cookieAuth) required
        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'application/json'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        return this.httpClient.get<Profile>(`${this.configuration.basePath}/profile/${encodeURIComponent(String(name))}`,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

    /**
     * Change user password
     * @param passwordChange 
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public passwordPatch(passwordChange?: PasswordChange, observe?: 'body', reportProgress?: boolean): Observable<string>;
    public passwordPatch(passwordChange?: PasswordChange, observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<string>>;
    public passwordPatch(passwordChange?: PasswordChange, observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<string>>;
    public passwordPatch(passwordChange?: PasswordChange, observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let headers = this.defaultHeaders;

        // authentication (cookieAuth) required
        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'text/plain'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        // to determine the Content-Type header
        const consumes: string[] = [
            'application/json'
        ];
        const httpContentTypeSelected: string | undefined = this.configuration.selectHeaderContentType(consumes);
        if (httpContentTypeSelected !== undefined) {
            headers = headers.set('Content-Type', httpContentTypeSelected);
        }

        return this.httpClient.patch<string>(`${this.configuration.basePath}/password`,
            passwordChange,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

    /**
     * Reset your password
     * @param passwordReset 
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public passwordRequestResetPost(passwordReset?: PasswordReset, observe?: 'body', reportProgress?: boolean): Observable<string>;
    public passwordRequestResetPost(passwordReset?: PasswordReset, observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<string>>;
    public passwordRequestResetPost(passwordReset?: PasswordReset, observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<string>>;
    public passwordRequestResetPost(passwordReset?: PasswordReset, observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let headers = this.defaultHeaders;

        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'text/plain'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        // to determine the Content-Type header
        const consumes: string[] = [
            'application/json'
        ];
        const httpContentTypeSelected: string | undefined = this.configuration.selectHeaderContentType(consumes);
        if (httpContentTypeSelected !== undefined) {
            headers = headers.set('Content-Type', httpContentTypeSelected);
        }

        return this.httpClient.post<string>(`${this.configuration.basePath}/password/requestReset`,
            passwordReset,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

    /**
     * Change user password with reset token
     * @param passwordChange 
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public passwordResetPost(passwordChange?: PasswordChange, observe?: 'body', reportProgress?: boolean): Observable<User>;
    public passwordResetPost(passwordChange?: PasswordChange, observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<User>>;
    public passwordResetPost(passwordChange?: PasswordChange, observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<User>>;
    public passwordResetPost(passwordChange?: PasswordChange, observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let headers = this.defaultHeaders;

        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'text/plain',
            'application/json'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        // to determine the Content-Type header
        const consumes: string[] = [
            'application/json'
        ];
        const httpContentTypeSelected: string | undefined = this.configuration.selectHeaderContentType(consumes);
        if (httpContentTypeSelected !== undefined) {
            headers = headers.set('Content-Type', httpContentTypeSelected);
        }

        return this.httpClient.post<User>(`${this.configuration.basePath}/password/reset`,
            passwordChange,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

    /**
     * Delete your account
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public profileDeletePost(observe?: 'body', reportProgress?: boolean): Observable<string>;
    public profileDeletePost(observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<string>>;
    public profileDeletePost(observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<string>>;
    public profileDeletePost(observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let headers = this.defaultHeaders;

        // authentication (cookieAuth) required
        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'text/plain'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        return this.httpClient.post<string>(`${this.configuration.basePath}/profile/delete`,
            null,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

    /**
     * Get user profile
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public profileGet(observe?: 'body', reportProgress?: boolean): Observable<User>;
    public profileGet(observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<User>>;
    public profileGet(observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<User>>;
    public profileGet(observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let headers = this.defaultHeaders;

        // authentication (cookieAuth) required
        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'application/json'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        return this.httpClient.get<User>(`${this.configuration.basePath}/profile`,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

    /**
     * Update user profile
     * @param profile 
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public profilePatch(profile?: Profile, observe?: 'body', reportProgress?: boolean): Observable<string>;
    public profilePatch(profile?: Profile, observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<string>>;
    public profilePatch(profile?: Profile, observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<string>>;
    public profilePatch(profile?: Profile, observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let headers = this.defaultHeaders;

        // authentication (cookieAuth) required
        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'text/plain'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        // to determine the Content-Type header
        const consumes: string[] = [
            'application/json'
        ];
        const httpContentTypeSelected: string | undefined = this.configuration.selectHeaderContentType(consumes);
        if (httpContentTypeSelected !== undefined) {
            headers = headers.set('Content-Type', httpContentTypeSelected);
        }

        return this.httpClient.patch<string>(`${this.configuration.basePath}/profile`,
            profile,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

    /**
     * Confirm a registration
     * @param token 
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public register(token?: Token, observe?: 'body', reportProgress?: boolean): Observable<User>;
    public register(token?: Token, observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<User>>;
    public register(token?: Token, observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<User>>;
    public register(token?: Token, observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let headers = this.defaultHeaders;

        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'application/json'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        // to determine the Content-Type header
        const consumes: string[] = [
            'application/json'
        ];
        const httpContentTypeSelected: string | undefined = this.configuration.selectHeaderContentType(consumes);
        if (httpContentTypeSelected !== undefined) {
            headers = headers.set('Content-Type', httpContentTypeSelected);
        }

        return this.httpClient.post<User>(`${this.configuration.basePath}/register`,
            token,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

    /**
     * Log in to the system
     * @param userLogin 
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public userLogin(userLogin?: UserLogin, observe?: 'body', reportProgress?: boolean): Observable<User>;
    public userLogin(userLogin?: UserLogin, observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<User>>;
    public userLogin(userLogin?: UserLogin, observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<User>>;
    public userLogin(userLogin?: UserLogin, observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let headers = this.defaultHeaders;

        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'application/json'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        // to determine the Content-Type header
        const consumes: string[] = [
            'application/json'
        ];
        const httpContentTypeSelected: string | undefined = this.configuration.selectHeaderContentType(consumes);
        if (httpContentTypeSelected !== undefined) {
            headers = headers.set('Content-Type', httpContentTypeSelected);
        }

        return this.httpClient.post<User>(`${this.configuration.basePath}/login`,
            userLogin,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

    /**
     * Log out of the system
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public userLogout(observe?: 'body', reportProgress?: boolean): Observable<string>;
    public userLogout(observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<string>>;
    public userLogout(observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<string>>;
    public userLogout(observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let headers = this.defaultHeaders;

        // authentication (cookieAuth) required
        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'text/plain'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        return this.httpClient.post<string>(`${this.configuration.basePath}/logout`,
            null,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

    /**
     * Create a new user
     * @param userDraft 
     * @param observe set whether or not to return the data Observable as the body, response or events. defaults to returning the body.
     * @param reportProgress flag to report request and response progress.
     */
    public usersPost(userDraft?: UserDraft, observe?: 'body', reportProgress?: boolean): Observable<User>;
    public usersPost(userDraft?: UserDraft, observe?: 'response', reportProgress?: boolean): Observable<HttpResponse<User>>;
    public usersPost(userDraft?: UserDraft, observe?: 'events', reportProgress?: boolean): Observable<HttpEvent<User>>;
    public usersPost(userDraft?: UserDraft, observe: any = 'body', reportProgress: boolean = false ): Observable<any> {

        let headers = this.defaultHeaders;

        // to determine the Accept header
        const httpHeaderAccepts: string[] = [
            'application/json'
        ];
        const httpHeaderAcceptSelected: string | undefined = this.configuration.selectHeaderAccept(httpHeaderAccepts);
        if (httpHeaderAcceptSelected !== undefined) {
            headers = headers.set('Accept', httpHeaderAcceptSelected);
        }


        // to determine the Content-Type header
        const consumes: string[] = [
            'application/json'
        ];
        const httpContentTypeSelected: string | undefined = this.configuration.selectHeaderContentType(consumes);
        if (httpContentTypeSelected !== undefined) {
            headers = headers.set('Content-Type', httpContentTypeSelected);
        }

        return this.httpClient.post<User>(`${this.configuration.basePath}/users`,
            userDraft,
            {
                withCredentials: this.configuration.withCredentials,
                headers: headers,
                observe: observe,
                reportProgress: reportProgress
            }
        );
    }

}
