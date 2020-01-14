import { Injectable } from '@angular/core';
import { AuthService } from 'angularx-social-login';
import { Store, Action } from '@ngrx/store';
import { AuthActions, AuthApiActions } from '../actions';

import * as fromAuth from '../reducers';
import { Observable, of } from 'rxjs';
import { User, OAuth2Login } from '../../core/openapi/lingua-poly';

// FIXME! This service is unnecessary!
@Injectable({
	providedIn: 'root'
})
export class OAuth2Service {

	constructor(
		private authService: AuthService,
		private authStore: Store<fromAuth.State>
	) {
		this.authService.authState.subscribe((user) => {
			this.authStore.dispatch(AuthActions.socialLogin({ user }))
		});
	}

	signIn(provider: OAuth2Login.ProviderEnum): Observable<User> {
		console.log('signing in with provider ' + provider);

		const user = {
			username: 'Humpty Dumpty',
			email: 'humpty@dumpty.com',
			homepage: 'http://humpty.dumpty.com',
			description: 'Humpty dumpties.'
		};

		return of(user);
	}
}
