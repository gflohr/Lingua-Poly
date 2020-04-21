import { Injectable, Inject } from '@angular/core';
import { createEffect, Actions, ofType } from '@ngrx/effects';
import { exhaustMap, map, catchError, tap, switchMap } from 'rxjs/operators';
import { UsersService, OauthService } from '../core/openapi/lingua-poly';
import { of } from 'rxjs';
import { LoginPageActions, AuthApiActions, AuthActions } from './actions';
import { Router } from '@angular/router';
import { AccountActions } from '../user/actions';
import { LogoutConfirmationComponent } from '../layout/components/logout-confirmation/logout-confirmation.component';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import * as fromAuth from './reducers';
import { Store } from '@ngrx/store';
import { ModalDialogService } from '../core/services/modal-dialog.service';
import { DOCUMENT } from '@angular/common';

@Injectable()
export class AuthEffects {

	constructor(
		@Inject(DOCUMENT) private document: Document,
		private actions$: Actions,
		private usersService: UsersService,
		private oauthService: OauthService,
		private router: Router,
		private dialogService: ModalDialogService,
		private authStore: Store<fromAuth.State>,
	) {
	}

	login$ = createEffect(() => this.actions$.pipe(
		ofType(LoginPageActions.login),
		map(action => action.credentials),
		exhaustMap((userLogin) =>
			this.usersService.userLogin(userLogin).pipe(
				map(user => AuthApiActions.loginSuccess({ user })),
				tap(() => this.router.navigate(['/'])),
				catchError(error => of(AuthApiActions.loginFailure({ error })))
			)
		)
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
		switchMap(action =>
			this.oauthService.oauthProviderAuthorizationUrlGet(action.provider).pipe(
				tap(url => this.document.location.href = url.href),
				catchError(error => of(AuthApiActions.logoutFailure({ error })))
			),
		)
	), { dispatch: false });
}
