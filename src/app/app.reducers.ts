import { UserStateRecord, UserState } from './user/states/user.state';
import { ActionReducerMap, MetaReducer } from '@ngrx/store';
import { AppState } from './app.interfaces';

import * as fromLayout from './core/reducers/layout.reducer';

export interface State {
	[fromLayout.layoutFeatureKey]: fromLayout.State
};

export const initialState = {
	user: new UserStateRecord() as UserState
};

export const metaReducers: MetaReducer<AppState>[] = [];
