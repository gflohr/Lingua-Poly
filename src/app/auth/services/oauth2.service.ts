import { Injectable } from '@angular/core';
import { AuthService, FacebookLoginProvider } from 'angularx-social-login';
import { Store } from '@ngrx/store';
import { AuthActions, AuthApiActions } from '../actions';

import * as fromAuth from '../reducers';
import { Observable, of } from 'rxjs';
import { User, OAuth2Login } from '../../core/openapi/lingua-poly';

@Injectable({
	providedIn: 'root'
})
export class OAuth2Service {

	constructor(
		private authService: AuthService,
		private authStore: Store<fromAuth.State>
	) {
		this.authService.authState.subscribe((socialUser) => {
			if (socialUser === null) {
				// FIXME! Only log the user out if the auth provider is
				// *not* null.
				this.authStore.dispatch(AuthActions.logout());
			} else if (socialUser !== null) {
				// FIXME! Send API request to /socialLogin with the authToken
				// instead of logging the user in immediately.
				const user = {
					username: 'Humpty Dumpty',
					email: 'humpty@dumpty.com',
					homepage: 'http://humpty.dumpty.com',
					description: 'Humpty dumpties.'
				};

				this.authStore.dispatch(AuthApiActions.loginSuccess(
					{
						user,
						provider: 'FACEBOOK'
					}
				));
			}
		});
	}

	signIn(provider: OAuth2Login.ProviderEnum) {
		switch (provider) {
			case OAuth2Login.ProviderEnum.FACEBOOK:
				this.authService.signIn(FacebookLoginProvider.PROVIDER_ID);
				break;
			case OAuth2Login.ProviderEnum.GOOGLE:
				throw new Error('Google login not yet implemented');
		}
	}
}
