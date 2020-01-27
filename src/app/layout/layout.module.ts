import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { RouterModule } from '@angular/router';
import { CoreModule } from '../core/core.module';

import { HeaderComponent } from './components/header/header.component';
import { FooterComponent } from './components/footer/footer.component';
import { SidebarComponent } from './components/sidebar/sidebar.component';
import { LogoutConfirmationComponent } from './components/logout-confirmation/logout-confirmation.component';
import { ErrorMessageComponent } from './components/error-message/error-message.component';

@NgModule({
	imports: [
		CommonModule,
		NgbModule,
		RouterModule,
		CoreModule
	],
	exports: [
		HeaderComponent,
		FooterComponent,
		SidebarComponent
	],
	declarations: [
		HeaderComponent,
		FooterComponent,
		SidebarComponent,
		LogoutConfirmationComponent,
		ErrorMessageComponent
	],
	entryComponents: [
		LogoutConfirmationComponent,
		ErrorMessageComponent
	]
})
export class LayoutModule { }
