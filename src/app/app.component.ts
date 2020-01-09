import { Component, OnInit, OnDestroy } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { Router, ActivatedRoute, Event, NavigationEnd } from '@angular/router';
import { applicationConfig } from './app.config';

import * as fromAuth from './auth/reducers';
import * as fromRoot from './app.reducers';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';

@Component({
	selector: 'app-root',
	templateUrl: './app.component.html',
	styleUrls: ['./app.component.css']
})

export class AppComponent implements OnInit, OnDestroy {
	loggedIn$: Observable<boolean>;

	constructor(
		private translate: TranslateService,
		private store: Store<fromRoot.State & fromAuth.State>
	) {
		this.translate.setDefaultLang(applicationConfig.defaultLocale);
		this.translate.use(applicationConfig.defaultLocale);

		this.loggedIn$ = this.store.pipe(select(fromAuth.selectLoggedIn));
	}

	ngOnInit() {
	}

	ngOnDestroy() {
	}
}
