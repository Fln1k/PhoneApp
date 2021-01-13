public with sharing class StudentsWithCourses{
	public static Map<String, List<Result>> getStudents(List<String> studentNames){
		List<Skill__c> skills = [SELECT Name, (SELECT Student__r.Name
		                                       FROM Preferences__r
		                                       WHERE Student__r.Name IN :studentNames), (SELECT Course__r.Name
		                                                                                  FROM Disciplines__r)
								 FROM Skill__c
								 WITH SECURITY_ENFORCED];

		Map<String, List<String>> students = new Map<String, List<String>>();
		Map<String, List<String>> courses = new Map<String, List<String>>();
		for (Skill__c skill : skills){
			for (Preference__c preference : skill.Preferences__r){
				String studentName = preference.Student__r.Name;
				if (students.containsKey(studentName)){
					students.get(studentName).add(skill.Name);
				} else{
					students.put(studentName, new List<String>{skill.Name});
				}
			}
			for (Discipline__c discipline : skill.Disciplines__r){
				String courseName = discipline.Course__r.Name;
				if (courses.containsKey(courseName)){
					courses.get(courseName).add(skill.Name);
				} else{
					courses.put(courseName, new List<String>{skill.Name});
				}
			}
		}

		Map<String, List<Result>> result = new Map<String, List<Result>>();
		for (String courseName : courses.keySet()){
			for (String studentName : students.keySet()){
				if (result.containsKey(studentName)){
					result.get(studentName).add(new Result(courseName, StudentsWithCourses.compare(courses.get(courseName), students.get(studentName))));
				} else{
					result.put(studentName, new List<Result>{new Result(courseName, StudentsWithCourses.compare(courses.get(courseName), students.get(studentName)))});
				}
			}
		}

		return result;
	}

	public static Double compare(List<String> courseSkills, List<String> studentSkills){
		Integer coincidence = 0;
		for (String skill : studentSkills){
			if (courseSkills.contains(skill)){
				++coincidence;
			}
		}
		return Double.valueOf(coincidence) / courseSkills.size() * 100;
	}
}