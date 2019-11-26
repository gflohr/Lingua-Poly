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
import { ROOT_REDUCERS } from './app.reducers';

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
	RouterModule.forRoot(appRoutes),
	StoreModule.forRoot(ROOT_REDUCERS),
	StoreRouterConnectingModule.forRoot({
		routerState: RouterState.Minimal
	})
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
