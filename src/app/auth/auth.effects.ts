import { Injectable } from '@angular/core';
import { createEffect, Actions, ofType } from '@ngrx/effects';
import { exhaustMap, map, catchError, tap, switchMap } from 'rxjs/operators';
import { UsersService } from '../core/openapi/lingua-poly';
import { of, from } from 'rxjs';
import { LoginPageActions, AuthApiActions, AuthActions } from './actions';
import { Router } from '@angular/router';
import { UserActions } from '../core/actions';
import { LogoutConfirmationComponent } from '../layout/components/logout-confirmation/logout-confirmation.component';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { OAuth2Service } from './services/oauth2.service';
import * as fromAuth from './reducers';
import { Store } from '@ngrx/store';
import { ModalDialogService } from '../core/services/modal-dialog.service';

@Injectable()
export class AuthEffects {

	constructor(
		private actions$: Actions,
		private usersService: UsersService,
		private router: Router,
		private dialogService: ModalDialogService,
		private oauth2Service: OAuth2Service,
		private authStore: Store<fromAuth.State>,
	) {
	}

	login$ = createEffect(() => this.actions$.pipe(
		ofType(LoginPageActions.login),
		map(action => action.credentials),
		exhaustMap((userLogin) =>
			this.usersService.userLogin(userLogin).pipe(
				map(user => AuthApiActions.loginSuccess({ user, provider: null })),
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
		exhaustMap(() => this.dialogService.runDialog(LogoutConfirmationComponent).pipe(
			map(() => AuthActions.logout()),
			catchError(() => of(AuthActions.logoutConfirmationDismiss()))
		))
	));

	logout$ = createEffect(() => this.actions$.pipe(
		ofType(AuthActions.logout),
		switchMap(() =>
			this.usersService.userLogout().pipe(
				tap(() => this.oauth2Service.signOut()),
				map(() => AuthApiActions.logoutSuccess()),
				catchError(error => of(AuthApiActions.logoutFailure({ error })))
			),
		)
	));

	logoutSuccess$ = createEffect(() => this.actions$.pipe(
		ofType(AuthApiActions.logoutSuccess),
		tap(() => this.router.navigate(['/']))
	), { dispatch: false });

	oauth2LoginRequest$ = createEffect(() => this.actions$.pipe(
		ofType(LoginPageActions.socialLoginRequest),
		map(action => this.oauth2Service.signIn(action.provider))
	), { dispatch: false });

	oauth2Login$ = createEffect(() => this.actions$.pipe(
		ofType(AuthActions.socialLogin),
		map(action => ({ token: action.socialUser.authToken, provider:action.provider })),
		exhaustMap(payload =>
			this.usersService.oauth2Login(payload).pipe(
				map(user => AuthApiActions.loginSuccess({ user, provider: payload.provider })),
				catchError(error => of(AuthApiActions.loginFailure({ error })))
		))
	));

	oauth2Logout$ = createEffect(() => this.actions$.pipe(
		ofType(AuthActions.socialLogout),
		map(() => this.oauth2Service.logout())
	), { dispatch: false });
}
