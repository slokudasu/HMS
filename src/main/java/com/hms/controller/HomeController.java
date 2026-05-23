package com.hms.controller;


import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.hms.dto.MenuItem;
import com.hms.entity.Maintenance;
import com.hms.entity.restaurent.RestaurantUser;
import com.hms.restaurent.repository.RestaurantUserRepository;
import com.hms.service.MaintenanceService;
import com.hms.service.MemberService;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {	

	private static final DateTimeFormatter SUBSCRIPTION_DATE_FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy");
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	MaintenanceService maintenanceService;

	@Autowired
	RestaurantUserRepository restaurantUserRepository;

	@RequestMapping(value="/membership", method = RequestMethod.GET)
	public String homePage() {
		return "Membership";
	}
	
	@RequestMapping(value="/maintenancePage", method = RequestMethod.GET)
	public String Maintenance() {		
		return "Maintenance";
	}
	
	@RequestMapping(value="/home", method = RequestMethod.GET)
	public String home() {		
		return "HomePage";
	}
	@RequestMapping(value="/transactions", method = RequestMethod.GET)
	public String Transactions() {		
		return "Transactions";
	}
	
	@RequestMapping(value="/report", method = RequestMethod.GET)
	public String report() {		
		return "report";
	}
	@RequestMapping(value="/builder", method = RequestMethod.GET)
	public String builder() {		
		return "builder";
	}
	
	@RequestMapping(value="/paymentReceipt/{id}", method = RequestMethod.GET)
	public String paymentReceipt (@PathVariable Long id,Model model) {
		if(id != null) {
			Optional<Maintenance> data = maintenanceService.edit(id);
			 if(data.isPresent()) {
				 model.addAttribute("id", data.get().getId());	
				 model.addAttribute("memberName", data.get().getMemberName());
				 model.addAttribute("month", data.get().getMonth());
				 model.addAttribute("year", data.get().getYear());
				 model.addAttribute("amount", data.get().getAmount());
				 model.addAttribute("date", data.get().getCreationDateTime());
				 
				 LocalDate date = LocalDate.parse(data.get().getCreationDateTime().toString());

			        // Define desired output format
			        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("dd-MMMM-yyyy");

			        // Format the date
			        String formattedDate = date.format(outputFormatter);
			        
			        model.addAttribute("date", formattedDate);
			        return "PaymentReceipt";
			 }
		}
		return null;
		 
		
		
	}
	
	@RequestMapping(value="/membershipCard/{id}", method = RequestMethod.GET)
	public String membershipCard (@PathVariable Long id,Model model) {		
		return "membershipCard";
		
	}
	@RequestMapping(value="/rest", method = RequestMethod.GET)
	public String rest (Model model, HttpSession session, HttpServletResponse response) {
		if (!isRestaurantSessionActive(session)) {
			return "redirect:/login";
		}
		if (isRestaurantSubscriptionExpired(session)) {
			return "redirect:/subscription-payment";
		}
		applyNoCacheHeaders(response);

		List<MenuItem> leftSideMenuItems = Arrays.asList(
			    new MenuItem("Soups", 120),
			    new MenuItem("Biryani", 100),
			    new MenuItem("Mushroom Soup", 130)
			);

		model.addAttribute("leftSideMenuItems", leftSideMenuItems);
		model.addAttribute("restaurantName", session.getAttribute("restaurantName"));
		model.addAttribute("subscriptionExpiryWarningMessage", buildSubscriptionExpiryWarningMessage(session));
		return "restaurantHomePage";
		
	}

	@RequestMapping(value="/restaurantHomePage.jsp", method = RequestMethod.GET)
	public String restaurantHomePageAlias() {
		return "redirect:/rest";
	}

	@RequestMapping(value="/newOrder", method = RequestMethod.GET)
	public String table (HttpSession session, HttpServletResponse response) {		
		if (!isRestaurantSessionActive(session)) {
			return "redirect:/login";
		}
		if (isRestaurantSubscriptionExpired(session)) {
			return "redirect:/subscription-payment";
		}
		applyNoCacheHeaders(response);
		return "newOrder";
		
	}
	@RequestMapping(value="/tableMenu/{id}", method = RequestMethod.GET)
	public String index2 (@PathVariable Long id,Model model, HttpSession session, HttpServletResponse response) {	
		if (!isRestaurantSessionActive(session)) {
			return "redirect:/login";
		}
		if (isRestaurantSubscriptionExpired(session)) {
			return "redirect:/subscription-payment";
		}
		applyNoCacheHeaders(response);

		List<MenuItem> menuList = Arrays.asList(
			    new MenuItem("Sweet Corn Soup", 120),
			    new MenuItem("Tomato Soup", 100),
			    new MenuItem("Mushroom Soup", 130)
			);

		model.addAttribute("menuList", menuList);
		System.err.print(menuList.size());
		return "tableMenu";
		
	}
	
	@RequestMapping(value="/configuration", method = RequestMethod.GET)
	public String configuration (HttpSession session, HttpServletResponse response) {		
		if (!isRestaurantSessionActive(session)) {
			return "redirect:/login";
		}
		if (isRestaurantSubscriptionExpired(session)) {
			return "redirect:/subscription-payment";
		}
		applyNoCacheHeaders(response);
		return "configuration";		
	}

	private boolean isRestaurantSessionActive(HttpSession session) {
		return session != null && session.getAttribute("restaurantUserId") != null;
	}

	private boolean isRestaurantSubscriptionExpired(HttpSession session) {
		if (session == null) {
			return false;
		}

		Object expiredValue = session.getAttribute("restaurantSubscriptionExpired");
		if (expiredValue instanceof Boolean boolValue) {
			return boolValue;
		}

		if (expiredValue != null) {
			return "true".equalsIgnoreCase(String.valueOf(expiredValue).trim());
		}
		return false;
	}

	private String buildSubscriptionExpiryWarningMessage(HttpSession session) {
		LocalDate subscriptionEndDate = resolveSubscriptionEndDate(session);
		if (subscriptionEndDate == null) {
			return "";
		}

		String formattedEndDate = subscriptionEndDate.format(SUBSCRIPTION_DATE_FORMATTER);
		long daysLeft = ChronoUnit.DAYS.between(LocalDate.now(), subscriptionEndDate);
		if (daysLeft < 0 || daysLeft > 5) {
			return "";
		}
		if (daysLeft == 0) {
			return "Subscription expires today (" + formattedEndDate + "). Please renew now to avoid service interruption.";
		}
		return "Subscription will expire in " + daysLeft + " day(s) on " + formattedEndDate + ". Please renew soon.";
	}

	private LocalDate resolveSubscriptionEndDate(HttpSession session) {
		if (session == null) {
			return null;
		}

		Object endDateValue = session.getAttribute("restaurantSubscriptionEndDate");
		LocalDate parsedFromSession = parseDateValue(endDateValue);
		if (parsedFromSession != null) {
			return parsedFromSession;
		}

		Long userId = resolveRestaurantUserId(session.getAttribute("restaurantUserId"));
		if (userId == null || userId <= 0) {
			return null;
		}

		Optional<RestaurantUser> userOptional = restaurantUserRepository.findById(userId);
		if (userOptional.isEmpty()) {
			return null;
		}

		return userOptional.get().getSubscriptionEndDate();
	}

	private LocalDate parseDateValue(Object dateValue) {
		if (dateValue == null) {
			return null;
		}

		if (dateValue instanceof LocalDate localDate) {
			return localDate;
		}

		String raw = String.valueOf(dateValue).trim();
		if (raw.isEmpty()) {
			return null;
		}

		try {
			return LocalDate.parse(raw, SUBSCRIPTION_DATE_FORMATTER);
		} catch (DateTimeParseException ignored) {
			try {
				return LocalDate.parse(raw, DateTimeFormatter.ISO_DATE);
			} catch (DateTimeParseException ignoredAgain) {
				return null;
			}
		}
	}

	private Long resolveRestaurantUserId(Object value) {
		if (value == null) {
			return null;
		}
		if (value instanceof Number numberValue) {
			long id = numberValue.longValue();
			return id > 0 ? id : null;
		}
		try {
			long id = Long.parseLong(String.valueOf(value).trim());
			return id > 0 ? id : null;
		} catch (NumberFormatException ex) {
			return null;
		}
	}

	private void applyNoCacheHeaders(HttpServletResponse response) {
		if (response == null) {
			return;
		}
		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);
	}
	
	
	
	

	
}
