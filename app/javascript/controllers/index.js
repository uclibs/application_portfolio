import { application } from "./application"
import FilterManagementController from "./filter_management_controller"
import InputSanitizationController from "./input_sanitization_controller"
import MultiValueInputsController from "./multi_value_inputs_controller"
import NavigationController from "./navigation_controller"
import ShowTabController from "./show_tab_controller"

application.register("filter-management", FilterManagementController)
application.register("input-sanitization", InputSanitizationController)
application.register("multi-value-inputs", MultiValueInputsController)
application.register("navigation", NavigationController)
application.register("show-tab", ShowTabController)
