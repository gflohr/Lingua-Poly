import { Injectable } from '@angular/core';
import { AuthService } from 'angularx-social-login';
import { Store } from '@ngrx/store';
import { AuthActions } from '../actions';

import * as fromAuth from '../reducers';
import { Observable, of } from 'rxjs';
import { User } from '../../core/openapi/lingua-poly';

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

	// FIXME: Should return an Observable<Action> and provider should be
	// an enum.
	signIn(provider: String): Observable<User> {
		console.log('signing in with provider ' + provider);
		return of({
			username: 'Humpty Dumpty',
			email: 'humpty@dumpty.com',
			homepage: 'http://humpty.dumpty.com',
			description: 'Humpty dumpties.'
		});
	}
}
