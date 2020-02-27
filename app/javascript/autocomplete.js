import autocomplete from "autocompleter";
import axios from "axios"

document.addEventListener("turbolinks:load", () => {
  const serviceName = document.querySelector("#service_name");
  if (!serviceName) {
    return null;
  }

  const servicePlan = document.querySelector("#service_plan");
  const servicePrice = document.querySelector("#service_price");
  let serviceList = []
  axios.get("/api/preset_services.json")
    .then(responce => {
      return responce.data
    })
    .then(json => {
      serviceList = json
    })

  autocomplete({
    input: serviceName,
    render: function(item, currentValue) {
      let div = document.createElement("div");
      div.textContent = item.name;
      return div;
    },
    fetch: function(text, update) {
      text = text.toLowerCase();
      let suggestions = serviceList.filter(n => n.name.toLowerCase().startsWith(text));
      update(suggestions);
    },
    preventSubmit: true,
    onSelect: function(item) {
      serviceName.value = item.name;
      servicePlan.selectedIndex = item.plan;
      servicePrice.value = item.price;
    }
  });
});
