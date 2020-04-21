import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { Store, select } from '@ngrx/store';

import * as fromAuth from '../../../auth/reducers';
import { AuthActions } from '../../../auth/actions';


@Component({
	selector: 'app-sidebar',
	templateUrl: './sidebar.component.html',
	styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent {
	loggedIn$: Observable<boolean>;

	constructor(
		private authStore: Store<fromAuth.State>
	) {
		this.loggedIn$ = this.authStore.pipe(select(fromAuth.selectLoggedIn));
	}

	logout() {
		this.authStore.dispatch(AuthActions.logoutConfirmation());
		return false;
	}
}
