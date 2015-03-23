var cleanFilters = function(filters) {
  var cleanedFilters = [];
  filters.forEach(function(element) {
    cleanedFilters.push(element.match(/\[(.*?)\]/)[1]);
  });
  return cleanedFilters;
};


var appendProjects = function(projects) {
  projects.forEach(function(project) {
    appendProject(project);
  });
};

var renderProjects = function(filteredProjects) {
  $("#projects").empty();
  appendProjects(filteredProjects);
};

var filterProjectsByCategory = function(projects, checkedFilters) {
  return projects.filter(function(project) {
    return project.categories.some(function(category) {
      return checkedFilters.indexOf(category) > -1;
    });
  });
};

var filterProjects = function(projects, checkedFilters) {
  projectsFilteredByCategory = filterProjectsByCategory(projects, checkedFilters);
  //return filterProjectsByPrice(projectsFilteredByCategory, checkedFilters);
  return projectsFilteredByCategory;
};

var initialCategories = function() {
  var initial_category_selected = window.location.href.slice(window.location.href.indexOf('=') + 1);
  var initial_categories = [];
  initial_categories.push(initial_category_selected);
  return initial_categories;
};
