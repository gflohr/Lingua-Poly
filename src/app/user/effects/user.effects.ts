import { Injectable } from '@angular/core';
import { Effect, ofType, Actions } from '@ngrx/effects';
import { Observable } from 'rxjs';
import { Action } from '@ngrx/store';
import { switchMap, catchError } from 'rxjs/operators';
import { UserDomainService } from 'src/app/core/services/domain/user.domain.service';
import { AppState } from 'src/app/app.interfaces';
import { Store } from '@ngrx/store';

@Injectable()
export class UserEffects {
	constructor(
		private store: Store<AppState>,
		private actions$: Actions,
		private userDomainService: UserDomainService
	) { }
}
