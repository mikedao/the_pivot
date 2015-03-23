## The Pivot

This is a project for the Turing School of Software and Design.
(http://turing.io)

The goal is to take legacy code, namely a website that was previously a site
for a restaurant, and turn it into a multi-tenant site.

We are building Keevah, a micro-lending platform, mimicking functionality of the Kiva Microfund's site, Kiva.org.

### Keevahh

Micro-lending is a powerful tool for social progress. Let’s rework Dinner Dash
into a micro-lending platform.

* Users register on the site as either a borrower (the business) or a lender
(the customer)
* Borrowers automatically have a borrower page (the store)
* Within that borrower page, they post one or more loan requests (the products)
* A loan request has a title, description, categories, photos, borrowing amount,
requested-by date, a repayments-begin date, and a repayment rate
* A lender can browse the site and view all open loan requests
* They can add multiple loans from multiple borrowers to their cart
* They can then checkout and the funds are allocated to the borrowers
* The borrowers are notified that funding has come through and their loan
request page is updated
* Lending like this is more fun together – it’d be great if lenders could band
together into lending groups that make loans together on a weekly or monthly basis.


### Functionality/tech highlights
- JavaScript filtering on the projects index page. When the page loads, an AJAx call is made to the endpoint in the projects controller which sends over JSON of all the projects. The checkboxes in the filter then narrow down those projects to the ones that were checked. It then empties out the projects section of the DOM and rerenders the selected projects into the projects ID section of the index.html.erb view.
- Session-based cart functionality
- User profile editing and signup forms and mailers.
- TDD with FactoryGirl


#### On this project:

* Emily Berkeley - https://github.com/EmilyMB

* Michael Dao - https://github.com/mikedao

* Orion Osborn - https://github.com/oorion

* Adam Smith - https://github.com/AdamSmith910

* Jeffrey Wan - https://github.com/Jwan622
