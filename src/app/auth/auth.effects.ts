import { Injectable } from '@angular/core';
import { createEffect, Actions, ofType } from '@ngrx/effects';
import { exhaustMap, map, catchError } from 'rxjs/operators';
import { UsersService } from '../core/openapi/lingua-poly';
import { AuthApiActions } from './actions/auth-api.actions';
import { LoginPageActions } from './actions/login-page.actions';
import { of } from 'rxjs';

@Injectable()
export class AuthEffects {
	login$ = createEffect(() =>
		this.actions$.pipe(
			ofType(LoginPageActions.login),
			exhaustMap(action =>
				this.usersService.userLogin(action ).pipe(
					map(user => AuthApiActions.loginSuccess(user)),
					catchError(error => of(AuthApiActions.loginFailure(error)))
				)
			)
		)
	);

	constructor(
		private actions$: Actions,
		private usersService: UsersService
	) { }
}
