import { Injectable } from '@angular/core';
import { Effect, ofType, Actions } from '@ngrx/effects';
import { Observable } from 'rxjs';
import { Action } from '@ngrx/store';
import { UserActions } from '../actions/user.actions';
import { switchMap, catchError } from 'rxjs/operators';
import { UserDomainService } from 'src/app/core/services/domain/user.domain.service';
import { AppState } from 'src/app/app.interfaces';
import { Store } from '@ngrx/store';

@Injectable()
export class UserEffects {
	constructor(
		private store: Store<AppState>,
		private actions$: Actions,
		private userDomainService: UserDomainService,
		private userActions: UserActions
	) { }

	@Effect()
	getProfile$: Observable<Action> = this.actions$.pipe(
		ofType(UserActions.GET_PROFILE),
		switchMap(() => this.userDomainService.getProfile()),
		switchMap(response => {
			const actions = [];
			actions.push(this.userActions.getProfileSuccess(response));

			return actions;
		}),
		catchError((error: Error, caught) => {
		  this.store.dispatch(this.userActions.getProfileError(error));
		  return caught;
		})
	  );
	}
