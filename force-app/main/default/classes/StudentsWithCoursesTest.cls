@isTest
public class StudentsWithCoursesTest{
	@testSetup
	static void setup(){
		List<Student__c> students = new List<Student__c>();
		students.add(new Student__c(Name = 'Vadim Plutin_1'));
		students.add(new Student__c(Name = 'Vadim Plutin_2'));
		students.add(new Student__c(Name = 'Vadim Plutin_3'));

		insert students;

		List<Skill__c> skills = new List<Skill__c>();
		skills.add(new Skill__c(Name = 'Java'));
		skills.add(new Skill__c(Name = 'Python'));
		skills.add(new Skill__c(Name = 'Ruby'));

		insert skills;

		List<Course__c> courses = new List<Course__c>();
		courses.add(new Course__c(Name = 'first'));
		courses.add(new Course__c(Name = 'second'));

		insert courses;

		List<Discipline__c> disciplines = new List<Discipline__c>();
		disciplines.add(new Discipline__c(Skill__c = skills[0].Id, Course__c = courses[1].Id));
		disciplines.add(new Discipline__c(Skill__c = skills[1].Id, Course__c = courses[1].Id));
		disciplines.add(new Discipline__c(Skill__c = skills[2].Id, Course__c = courses[1].Id));
		disciplines.add(new Discipline__c(Skill__c = skills[0].Id, Course__c = courses[0].Id));

		insert disciplines;

		List<Preference__c> pref = new List<Preference__c>();
		pref.add(new Preference__c(Student__c = students[0].Id, Skill__c = skills[0].Id));
		pref.add(new Preference__c(Student__c = students[0].Id, Skill__c = skills[1].Id));
		pref.add(new Preference__c(Student__c = students[0].Id, Skill__c = skills[2].Id));
		pref.add(new Preference__c(Student__c = students[1].Id, Skill__c = skills[0].Id));
		pref.add(new Preference__c(Student__c = students[1].Id, Skill__c = skills[1].Id));
		pref.add(new Preference__c(Student__c = students[2].Id, Skill__c = skills[0].Id));

		insert pref;
	}

	static testMethod void returnValidInformation(){
		List<String> students = new List<String>();
		students.add('Vadim Plutin_1');
		students.add('Vadim Plutin_2');
		students.add('Vadim Plutin_3');

		Map<String, List<Result>> result = StudentsWithCourses.getStudents(students);

		system.assertEquals('100.0%', result.get('Vadim Plutin_1')[0].percent, 'wrong match percentage');
		system.assertEquals('100.0%', result.get('Vadim Plutin_1')[1].percent, 'wrong match percentage');
		system.assertEquals('100.0%', result.get('Vadim Plutin_2')[0].percent, 'wrong match percentage');
		system.assertEquals('66.66666666666666%', result.get('Vadim Plutin_2')[1].percent, 'wrong match percentage');
		system.assertEquals('100.0%', result.get('Vadim Plutin_3')[0].percent, 'wrong match percentage');
		system.assertEquals('33.33333333333333%', result.get('Vadim Plutin_3')[1].percent, 'wrong match percentage');
	}
}