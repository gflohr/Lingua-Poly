import { Action } from '@ngrx/store';

export interface ReduxAction extends Action {
	payload?: any
}
