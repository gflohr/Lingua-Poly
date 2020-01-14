import { Injectable } from '@angular/core';
import { createEffect, Actions, ofType } from '@ngrx/effects';
import { exhaustMap, map, catchError, tap, switchMap } from 'rxjs/operators';
import { UsersService } from '../core/openapi/lingua-poly';
import { of, from } from 'rxjs';
import { LoginPageActions, AuthApiActions, AuthActions } from './actions';
import { Router } from '@angular/router';
import { UserActions } from '../core/actions';
import { LogoutConfirmationComponent } from '../layout/components/logout-confirmation/logout-confirmation.component';
import { AuthService, FacebookLoginProvider } from 'angularx-social-login';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';

import * as fromAuth from './reducers';
import { Store } from '@ngrx/store';

@Injectable()
export class AuthEffects {

	constructor(
		private actions$: Actions,
		private usersService: UsersService,
		private router: Router,
		private modalService: NgbModal,
		private authService: AuthService,
		private authStore: Store<fromAuth.State>
	) {
		authService.authState.subscribe((user) => {
			this.authStore.dispatch(AuthActions.socialLogin({ user }))
		});
	}

	login$ = createEffect(() => this.actions$.pipe(
		ofType(LoginPageActions.login),
		map(action => action.credentials),
		exhaustMap((userLogin) =>
			this.usersService.userLogin(userLogin).pipe(
				map(user => AuthApiActions.loginSuccess({ user })),
				catchError(error => of(AuthApiActions.loginFailure({ error })))
			)
		)
	));

	loginSuccess$ = createEffect(() => this.actions$.pipe(
		ofType(AuthApiActions.loginSuccess),
		tap(() => this.router.navigate(['/']))
	), { dispatch: false });

	logoutIdleUser$ = createEffect(() => this.actions$.pipe(
		ofType(UserActions.idleTimeout),
		map(() => AuthActions.logout())
	));

	logoutConfirmation$ = createEffect(() => this.actions$.pipe(
		ofType(AuthActions.logoutConfirmation),
		exhaustMap(() => this.runDialog(LogoutConfirmationComponent).pipe(
			map(() => AuthActions.logout()),
			catchError(() => of(AuthActions.logoutConfirmationDismiss()))
		))
	));

	logout$ = createEffect(() => this.actions$.pipe(
		ofType(AuthActions.logout),
		switchMap(() =>
			this.usersService.userLogout().pipe(
				map(() => AuthApiActions.logoutSuccess()),
				catchError(error => of(AuthApiActions.logoutFailure({ error })))
			)
		)
	));

	logoutSuccess$ = createEffect(() => this.actions$.pipe(
		ofType(AuthApiActions.loginSuccess),
		tap(() => this.router.navigate(['/']))
	), { dispatch: false });


	socialLogin$ = createEffect(() => this.actions$.pipe(
		ofType(LoginPageActions.socialLogin),
		map(action => {
			if (action.provider === 'FACEBOOK') {
				this.authService.signIn(FacebookLoginProvider.PROVIDER_ID)
			}
		})
	), { dispatch: false });

	/* FIXME! This should maybe go into a separate service.	*/
	runDialog = function(content) {
		const modalRef = this.modalService.open(content, { centered: true });

		return from(modalRef.result);
	};
}
