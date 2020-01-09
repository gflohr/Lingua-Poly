import { Injectable } from '@angular/core';
import { fromEvent, merge, timer, of } from 'rxjs';
import { createEffect, Actions, ofType } from '@ngrx/effects';
import { map, exhaustMap, switchMapTo, catchError, tap } from 'rxjs/operators';
import { UserActions } from '../actions';
import { UsersService, Profile } from '../openapi/lingua-poly';
import { UserApiActions } from 'src/app/user/actions';

@Injectable()
export class UserEffects {
	clicks$ = fromEvent(document, 'click');
	keys$ = fromEvent(document, 'keydown');
	mouse$ = fromEvent(document, 'mousemove');

	// FIXME! This is the wrong approach. Activity for us exclusively means
	// API calls.	And the maximum allowed idle time comes from the server.
	idle$ = createEffect(() =>
		merge(this.clicks$, this.keys$, this.mouse$).pipe(
			switchMapTo(timer(5 * 60 * 1000)), // 5 minute inactivity timeout
			map(() => UserActions.idleTimeout())
		)
	);

	getProfile$ = createEffect(() => this.actions$.pipe(
		ofType(UserActions.requestProfile),
		exhaustMap(() =>
			this.usersService.profileGet().pipe(
				map(user => UserApiActions.profileSuccess({ user })),
				catchError(error => of(UserApiActions.profileFailure({ error })))
			)
		)
	));

	setProfile$ = createEffect(() => this.actions$.pipe(
		ofType(UserActions.setProfile),
		exhaustMap((props) =>
			this.usersService.profilePatch(props.payload).pipe(
				map(profile => console.log(profile))
			)
		)
	), { dispatch: false });

	constructor(
		private actions$: Actions,
		private usersService: UsersService,
	) { }
}
