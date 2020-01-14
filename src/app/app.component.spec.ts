import { TestBed, async } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { AppComponent } from './app.component';
import { CoreModule } from './core/core.module';
import { LayoutModule } from './layout/layout.module';
import { ROOT_REDUCERS, metaReducers } from './app.reducers';
import { StoreModule } from '@ngrx/store';
import { SocialLoginModule, AuthServiceConfig, FacebookLoginProvider } from 'angularx-social-login';

const config = new AuthServiceConfig([
	{
		id: FacebookLoginProvider.PROVIDER_ID,
		provider: new FacebookLoginProvider('invalid')
	}
]);

export function provideConfig() {
	return config;
}

describe('AppComponent', () => {
	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [
				CoreModule,
				LayoutModule,
				RouterTestingModule,
				StoreModule.forRoot(ROOT_REDUCERS, { metaReducers }),
				SocialLoginModule
			],
			declarations: [
				AppComponent
			],
			providers: [
				{
					provide: AuthServiceConfig,
					useFactory: provideConfig
				}
			]
		}).compileComponents();
	}));

	it('should create the app', () => {
		const fixture = TestBed.createComponent(AppComponent);
		const app = fixture.debugElement.componentInstance;
		expect(app).toBeTruthy();
	});
});
