import { Application } from '@hotwired/stimulus';
import { registerControllers } from 'stimulus-vite-helpers';

const application = Application.start();

// Use Vite's import.meta.glob to find all controller files
const controllers = import.meta.glob('./**/*_controller.js', { eager: true });

// Register the found controllers with the Stimulus application
registerControllers(application, controllers);
