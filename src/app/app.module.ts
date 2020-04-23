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
import { ConfigEffects, RouterEffects, MessageEffects } from './core/effects';
import { UserModule } from './user/user.module';
import { StoreDevtoolsModule } from '@ngrx/store-devtools';
import { environment } from '../environments/environment';
import { ApiModule } from './core/openapi/lingua-poly';
import { AppLinguaComponent } from './app-lingua.component';
import { RouteContainerModule } from './route-container/route-container.module';
import { UserEffects } from './user/effects';
import { LinguaModule } from './lingua/lingua.module';
import { SharedModule } from './shared/shared.module';

@NgModule({
	declarations: [
		AppComponent,
		AppLinguaComponent
	],
	imports: [
		BrowserModule,
		CoreModule,
		LinguaModule,
		AuthModule,
		LayoutModule,
		MainModule,
		UserModule,
		RouterModule.forRoot(appRoutes),
		RouteContainerModule,
		StoreModule.forRoot(ROOT_REDUCERS, { metaReducers }),
		EffectsModule.forRoot([
			ConfigEffects,
			UserEffects,
			RouterEffects,
			MessageEffects,
		]),
		StoreRouterConnectingModule.forRoot({
			routerState: RouterState.Minimal
		}),
		StoreDevtoolsModule.instrument({ maxAge: 25, logOnly: environment.production }),
		ApiModule,
		SharedModule,
	],
	providers: [],
	bootstrap: [ AppLinguaComponent ],
})
export class AppModule { }
