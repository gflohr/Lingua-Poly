import { Component, OnInit } from '@angular/core';
import { Observable } from 'rxjs';

import * as fromAuth from 'src/app/auth/reducers';
import { Store, select } from '@ngrx/store';

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

}
