import { Component } from '@angular/core';
import { NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
	selector: 'app-delete-account-confirmation',
	templateUrl: './delete-account-confirmation.component.html',
	styleUrls: ['./delete-account-confirmation.component.css']
})
export class DeleteAccountConfirmationComponent {
	constructor(
		public activeModal: NgbActiveModal
	) { }
}

