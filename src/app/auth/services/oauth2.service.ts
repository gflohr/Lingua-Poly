import { Injectable } from '@angular/core';
import { AuthService, FacebookLoginProvider } from 'angularx-social-login';
import { Store, select, Action } from '@ngrx/store';
import { AuthActions } from '../actions';
import * as fromAuth from '../reducers';
import { Observable } from 'rxjs';
import { OAuth2Login, UsersService } from '../../core/openapi/lingua-poly';
import { map, filter } from 'rxjs/operators';

@Injectable({
	providedIn: 'root'
})
export class OAuth2Service {
	provider$: Observable<OAuth2Login.ProviderEnum>;

	constructor(
		private authService: AuthService,
		private authStore: Store<fromAuth.State>,
		private userService: UsersService
	) {
		this.provider$ = this.authStore.pipe(select(fromAuth.selectProvider));

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

	signOut() {
		this.authService.signOut();
	}

	logout(): Observable<Action> {
		return this.provider$.pipe(
			filter(provider => provider !== null),
			map(() => AuthActions.logout)
		);
	}
}
