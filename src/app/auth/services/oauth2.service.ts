import { Injectable } from '@angular/core';
import { AuthService, FacebookLoginProvider } from 'angularx-social-login';
import { Store, select } from '@ngrx/store';
import { AuthActions, AuthApiActions } from '../actions';
import * as fromAuth from '../reducers';
import { Observable } from 'rxjs';
import { OAuth2Login } from '../../core/openapi/lingua-poly';
import { switchMap, tap } from 'rxjs/operators';

@Injectable({
	providedIn: 'root'
})
export class OAuth2Service {
	provider$: Observable<OAuth2Login.ProviderEnum>;

	constructor(
		private authService: AuthService,
		private authStore: Store<fromAuth.State>
	) {
		this.provider$ = this.authStore.pipe(select(fromAuth.selectProvider));

		/*
		this.authService.authState.pipe(
			switchMap(socialUser => {
				return this.provider$.pipe(
					tap(provider => {
						console.log('state change');
						console.log(socialUser);
						console.log(provider);
					})
				);
			})
		).subscribe();
		*/

		this.authService.authState.subscribe(socialUser => {
			if (socialUser === null) {
				this.authStore.dispatch(AuthActions.socialLogout());
			} else {
				let provider: OAuth2Login.ProviderEnum;

				if ('FACEBOOK' === socialUser.provider) {
					provider = OAuth2Login.ProviderEnum.FACEBOOK;
				} else if ('GOOGLE' === socialUser.provider) {
					provider = OAuth2Login.ProviderEnum.GOOGLE
				} else {
					return;
				}

				this.authStore.dispatch(AuthActions.socialLogin({
					socialUser, provider
				}))
			}
		})

		/*
		this.authService.authState.subscribe((socialUser) => {
			console.log('auth state change');
			console.log(this.provider$);

			if (socialUser === null) {
				// FIXME! Only log the user out if the auth provider is
				// *not* null.
				console.log('auth provider has logged out the user');
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
		*/
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
