package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.metadata.Metadata;
import com.dat3m.dartagnan.program.event.metadata.MetadataMap;
import com.dat3m.dartagnan.program.event.metadata.SourceLocation;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.dat3m.dartagnan.verification.Context;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.*;

public abstract class Event implements Encoder, Comparable<Event> {

	public static final int PRINT_PAD_EXTRA = 50;

	// This id is dynamically changing during processing.
	protected transient int globalId = -1;		// (Global) ID within a program

	// The following three ids are snapshots of the global id at specific points in the processing.
	// They are meant to be fixed once assigned.
	protected int oId = -1; 	// Global ID after parsing (original), before any passes have been run
	protected int uId = -1;		// Global ID right before unrolling
	protected int cId = -1;		// Global ID right before compilation

	protected Thread thread; // The thread this event belongs to

	protected final Set<String> filter;

	protected transient Event successor;
	protected transient Event predecessor;

	protected MetadataMap metadataMap = new MetadataMap();

	protected Event(){
		filter = new HashSet<>();
	}

	protected Event(Event other){
		copyMetadataFrom(other);
        this.filter = other.filter; // TODO: Dangerous code! A Copy-on-Write Set should be used (e.g. PersistentSet/Map)
        this.thread = other.thread;
    }

	public void copyMetadataFrom(Event other) {
		this.oId = other.oId;
		this.uId = other.uId;
		this.cId = other.cId;
		other.metadataMap.getAllMetadata().forEach(this.metadataMap::put);
	}

	public boolean hasMetadata(Class<? extends Metadata> metadataClass) {
		return metadataMap != null && metadataMap.contains(metadataClass);
	}

	public <T extends Metadata> T getMetadata(Class<T> metadataClass) {
		return metadataMap == null ? null : metadataMap.get(metadataClass);
	}

	public <T extends Metadata> T setMetadata(T metadata) {
		if (metadataMap == null) {
			metadataMap = new MetadataMap();
		}
		return metadataMap.put(metadata);
	}

	public <T extends Metadata> boolean hasEqualMetadata(Event other, Class<T> metadataClass) {
		return Objects.equals(getMetadata(metadataClass), other.getMetadata(metadataClass));
	}

	public int getGlobalId() { return globalId; }
	public void setGlobalId(int id) { this.globalId = id; }
	public boolean hasGlobalId() { return globalId != -1; }

	public int getOId() { return oId; }
	public void setOId(int id) { this.oId = id; }
	public boolean hasOId() { return oId != -1; }

	public int getUId(){ return uId; }
	public void setUId(int id) { this.uId = id; }
	public boolean hasUId() { return uId != -1; }

	public int getCId() { return cId; }
	public void setCId(int id) { this.cId = id; }
	public boolean hasCId() { return cId != -1; }

	public Event setCFileInformation(int line, String sourceCodeFilePath) {
		this.metadataMap.put(new SourceLocation(sourceCodeFilePath, line));
		return this;
	}

	public Event getSuccessor() { return successor; }
	public Event getPredecessor() { return predecessor; }

	public void setSuccessor(Event event) {
		if (successor != null) {
			successor.predecessor = null;
		}
		if (event != null) {
			if (event.predecessor != null){
				event.predecessor.successor = null;
			}
			event.predecessor = this;
			event.setThread(this.thread);
		}
		successor = event;
	}

	public void setPredecessor(Event event) {
		if (predecessor != null) {
			predecessor.successor = null;
		}
		if (event != null) {
			if (event.successor != null){
				event.successor.predecessor = null;
			}
			event.successor = this;
			event.setThread(this.thread);
		}
		predecessor = event;
	}

	public Thread getThread() {
		return thread;
	}
	public void setThread(Thread thread) {
		Preconditions.checkNotNull(thread);
		this.thread = thread;
	}

	public final List<Event> getSuccessors(){
		List<Event> events = new ArrayList<>();
		Event cur = this;
		while (cur != null) {
			events.add( cur);
			cur = cur.getSuccessor();
		}

		return events;
	}

	public final List<Event> getPredecessors(){
		List<Event> events = new ArrayList<>();
		Event cur = this;
		while (cur != null) {
			events.add( cur);
			cur = cur.getPredecessor();
		}

		return events;
	}

	public boolean is(String param){
		return param != null && (filter.contains(param));
	}

	public void addFilters(Collection<? extends String> filters) { filter.addAll(filters); }
	public void addFilters(String... params){
		addFilters(Arrays.asList(params));
	}
	public void removeFilters(Collection<? extends String> filters) { filter.removeAll(filters); }
	public void removeFilters(String... params){
		removeFilters(Arrays.asList(params));
	}

	// The return value should not get modified directly.
	public Set<String> getFilters() {
		return filter;
	}

	public boolean hasFilter(String f) {
		return filter.contains(f);
	}

	@Override
	public int compareTo(Event e){
		if (e == this) {
			return 0;
		}
		int result = Integer.compare(this.getGlobalId(), e.getGlobalId());
		if (result == 0) {
			final String error = String.format("Events %s and %s are different but have the same global id %d",
					this, e, e.getGlobalId());
			throw new IllegalStateException(error);
		}
		return result;
	}

	// ============================ Utility methods ============================

	public void delete() {
		if (getPredecessor() != null) {
			getPredecessor().setSuccessor(this.getSuccessor());
		} else if (getSuccessor() != null) {
			this.getSuccessor().setPredecessor(null);
		}
	}

	public void insertAfter(Event toBeInserted) {
		if (this.successor != null) {
			this.successor.setPredecessor(toBeInserted);
		}
		this.setSuccessor(toBeInserted);
	}

	public void insertAfter(List<Event> toBeInserted) {
		Event cur = this;
		for (Event next : toBeInserted) {
			cur.insertAfter(next);
			cur = next;
		}
	}

	public void replaceBy(Event replacement) {
		this.insertAfter(replacement);
		this.delete();
	}

	// Unrolling
    // -----------------------------------------------------------------------------------------------------------------

	public Event getCopy(){
		throw new UnsupportedOperationException("Copying is not allowed for " + getClass().getSimpleName());
	}

	public void updateReferences(Map<Event, Event> updateMapping) { }

	// Visitor
	// -----------------------------------------------------------------------------------------------------------------

	public <T> T accept(EventVisitor<T> visitor) {
		return visitor.visitEvent(this);
	}

	// Encoding
	// -----------------------------------------------------------------------------------------------------------------

	public void runLocalAnalysis(Program program, Context context) { }

	// This method needs to get overwritten for conditional events.
	public boolean cfImpliesExec() {
		return true;
	}

	public BooleanFormula encodeExec(EncodingContext ctx) {
		return ctx.getBooleanFormulaManager().makeTrue();
	}
}