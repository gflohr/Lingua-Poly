import { createAction, props, Action } from '@ngrx/store';
import { User } from '../../core/openapi/lingua-poly';

export class AuthApiActions {
	static loginSuccess = createAction(
		'[Auth API] login success',
		props<{ user: User }>()
	);

	static loginFailure = createAction(
		'[Auth API] login failure',
		props<{ error: Error }>()
	);
}
