public class Result{
	public String course;
	public String percent;
	public Result(String course, Double percent){
		this.course = course;
		this.percent = String.valueOf(percent) + '%';
	}
}