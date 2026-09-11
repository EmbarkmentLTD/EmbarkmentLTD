// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import AdminChartsController from "controllers/admin_charts_controller"
import EmailValidationController from "controllers/email_validation_controller"
import HelloController from "controllers/hello_controller"

application.register("admin-charts", AdminChartsController)
application.register("email-validation", EmailValidationController)
application.register("hello", HelloController)