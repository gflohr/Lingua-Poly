import { Injectable } from '@angular/core';
import { createEffect, Actions, ofType } from '@ngrx/effects';
import { exhaustMap, map, catchError, tap, switchMap } from 'rxjs/operators';
import { UsersService } from '../core/openapi/lingua-poly';
import { of, from } from 'rxjs';
import { LoginPageActions, AuthApiActions, AuthActions } from './actions';
import { Router } from '@angular/router';
import { UserActions } from '../core/actions';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { LogoutConfirmationComponent } from '../layout/components/logout-confirmation/logout-confirmation.component';

@Injectable()
export class AuthEffects {

	constructor(
		private actions$: Actions,
		private usersService: UsersService,
		private router: Router,
		private modalService: NgbModal,
	) { }

	/* FIXME! This should maybe go into a separate service.	*/
	runDialog = function(content) {
		const modalRef = this.modalService.open(content, { centered: true });

		return from(modalRef.result);
	};

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
}
