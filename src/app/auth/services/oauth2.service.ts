import { Injectable } from '@angular/core';
import { Store, select, Action } from '@ngrx/store';
import { AuthActions } from '../actions';
import * as fromAuth from '../reducers';
import { Observable } from 'rxjs';
import { UsersService } from '../../core/openapi/lingua-poly';
import { map, filter, tap } from 'rxjs/operators';

@Injectable({
	providedIn: 'root'
})
export class OAuth2Service {
	constructor(
		private authStore: Store<fromAuth.State>,
		private userService: UsersService
	) {
	}

	signIn(provider: string) {
		switch (provider) {
			case 'facebook':
				console.log('login with facebook ...');
				break;
			case 'google':
				console.log('login with google ...');
				break;
		}
	}
}
