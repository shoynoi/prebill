import autocomplete from "autocompleter";

document.addEventListener("turbolinks:load", () => {
  const serviceName = document.querySelector("#service_name");
  if (!serviceName) {
    return null;
  }

  const servicePlan = document.querySelector("#service_plan");
  const servicePrice = document.querySelector("#service_price");
  let countries = [
    { label: "Amazon Prime月額プラン", value: "XX", plan: 0, price: 500 },
    { label: "Amazon Prime年間プラン", value: "XX", plan: 1, price: 4900 }
  ];

  autocomplete({
    input: serviceName,
    fetch: function(text, update) {
      text = text.toLowerCase();
      // you can also use AJAX requests instead of preloaded data
      let suggestions = countries.filter(n => n.label.toLowerCase().startsWith(text));
      update(suggestions);
    },
    onSelect: function(item) {
      serviceName.value = item.label;
      servicePlan.selectedIndex = item.plan;
      servicePrice.value = item.price;
    }
  });
});
