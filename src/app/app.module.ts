import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { CoreModule } from './core/core.module';
import { AuthModule } from './auth/auth.module';
import { LayoutModule } from './layout/layout.module';
import { MainModule } from './main/main.module';
import { RouterModule } from '@angular/router';
import { appRoutes } from './app.routes';

import { AppComponent } from './app.component';
import { StoreModule } from '@ngrx/store';
import { StoreRouterConnectingModule, RouterState } from '@ngrx/router-store';
import { ROOT_REDUCERS, metaReducers } from './app.reducers';
import { EffectsModule } from '@ngrx/effects';
import { ConfigEffects, UserEffects, RouterEffects } from './core/effects';
import { UserModule } from './user/user.module';
import { AuthServiceConfig, FacebookLoginProvider, SocialLoginModule, GoogleLoginProvider } from 'angularx-social-login';
import { StoreDevtoolsModule } from '@ngrx/store-devtools';
import { environment } from '../environments/environment';

const config = new AuthServiceConfig([
	{
		id: FacebookLoginProvider.PROVIDER_ID,
		provider: new FacebookLoginProvider(
			'2485272091733885',
			// Login options.
			{
				scope: 'email',
			},
			// Locale.
			'en_US',
			// Fields.
			'email',
			// Version.
			'v5.0',
		)
	},
	{
		id: GoogleLoginProvider.PROVIDER_ID,
		provider: new GoogleLoginProvider('166256393295-o8umcgjqf2q04lknkpp3cjbsk61jub2b.apps.googleusercontent.com')
	}
]);

export function provideConfig() {
	return config;
}

@NgModule({
	declarations: [
		AppComponent
	],
	imports: [
		BrowserModule,
		CoreModule,
		AuthModule,
		LayoutModule,
		MainModule,
		UserModule,
		RouterModule.forRoot(appRoutes),
		StoreModule.forRoot(ROOT_REDUCERS, { metaReducers }),
		StoreRouterConnectingModule.forRoot({
			routerState: RouterState.Minimal
		}),
		EffectsModule.forRoot([ConfigEffects, UserEffects, RouterEffects]),
		SocialLoginModule,
		StoreDevtoolsModule.instrument({ maxAge: 25, logOnly: environment.production })
	],
	providers: [
		{
			provide: AuthServiceConfig,
			useFactory: provideConfig
		}
	],
	bootstrap: [AppComponent]
})
export class AppModule { }
