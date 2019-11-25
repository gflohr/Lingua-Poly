import { createAction, props } from '@ngrx/store';
import { UserLogin } from '../../core/openapi/lingua-poly';

export class LoginPageActions {
	static login = createAction(
		'[Login page] login',
		props<UserLogin>()
	);
}
