import { createAction, props, Action } from '@ngrx/store';
import { UserLogin, User } from '../../core/openapi/lingua-poly';

export class AuthApiActions {
	static loginSuccess = createAction(
		'[Auth API] login success',
		props<User>()
	);

	static loginFailure = createAction(
		'[Auth API] login failure',
		props<Error>()
	);
}
