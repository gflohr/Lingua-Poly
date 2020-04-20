import { Component, OnInit, OnDestroy } from '@angular/core';
import { TranslateService } from '@ngx-translate/core';
import { applicationConfig } from './app.config';
import * as fromAuth from './auth/reducers';
import * as fromRoot from './app.reducers';
import { Store, select } from '@ngrx/store';
import { Observable } from 'rxjs';
import { ConfigActions, MessageActions } from './core/actions';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';

@Component({
	selector: 'app-root',
	templateUrl: './app.component.html',
	styleUrls: ['./app.component.css'],
})

export class AppComponent implements OnInit, OnDestroy {
	loggedIn$: Observable<boolean>;

	constructor(
		private translate: TranslateService,
		private store: Store<fromRoot.State & fromAuth.State>,
		private route: ActivatedRoute,
		private router: Router,
	) {
		this.translate.setDefaultLang(applicationConfig.defaultLocale);
		this.translate.use(applicationConfig.defaultLocale);

		this.loggedIn$ = this.store.pipe(select(fromAuth.selectLoggedIn));
	}

	ngOnInit() {
		this.store.dispatch(ConfigActions.configRequest());

		this.route.queryParamMap.subscribe((params: ParamMap) => {
			if (params.get('error') !== null) {
				this.store.dispatch(MessageActions.displayError({ code: params.get('error')} ));
				this.router.navigate([this.router.url.split('?')[0]]);
			}
		});

		this.route.paramMap.subscribe(params => {
			const lingua = params.get('lingua');
			console.log(`lingua: ${lingua}`);
		});
	}

	ngOnDestroy() {
	}
}
